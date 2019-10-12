function aisLiveData(liveFlag,logFlag)
%% This file can be used for decoding AIS captures made with the RTL-SDR
% To capture live AIS transmissions, tune the RTL-SDR to 162.025 MHz (lines
% 12-14).
% To capture AIS transmissions in a test environment, tune the RTL-SDR to
% 910 MHz or another ISM band (lines 15-17).

% Copyright 2016, The MathWorks, Inc.

samplesPerSymbol = 24;
if liveFlag
    RX = comm.SDRRTLReceiver('CenterFrequency',162.025e6,'EnableTunerAGC',...
            false,'TunerGain',60,'SampleRate',9600*samplesPerSymbol,'OutputDataType','single',...
            'SamplesPerFrame',262144);
%     RX = comm.SDRRTLReceiver('CenterFrequency',910e6,'EnableTunerAGC',...
%             true,'SampleRate',9600*samplesPerSymbol,'OutputDataType','single',...
%             'SamplesPerFrame',262144);
    nCaptures = 60;     % Each capture is about 1 second long
else
    [filename,pathname]=uigetfile('*.mat');
    load(strcat(pathname,'\',filename))
    nCaptures = 1;      % Each data file has 1 capture
end

% load aisSync24.mat
syncCalc = syncGen(samplesPerSymbol);
syncIdeal = unwrap(diff(angle(syncCalc(1:samplesPerSymbol*20+1))));

% plot(abs(data))

if logFlag
    logfile='capture.txt';
    fileID=fopen(logfile,'a');
end

% Checksum using comm.CRCGenerator
crcGen = comm.CRCGenerator('Polynomial','X^16 + X^12 + X^5 + 1',...
    'InitialConditions',1,'DirectMethod',true,'FinalXOR',1);

% Gaussian Filter Design
BT=.3;
pulseLength=3;
gx = gaussdesign(BT,pulseLength,samplesPerSymbol);

% Phase Extractor
phaseCalc=dsp.PhaseExtractor;

% Loop for nCaptures
for nn=1:nCaptures
    % Loop until find invalid message
    validCRC=1;
    if liveFlag
        data = step(RX);
    else
        data=double(data);
    end
    while validCRC
%         plot(abs(data))
        
        % Find strongest RX signal in capture
        windowLen = RX.SamplesPerFrame/128;
        l=floor(length(data)/windowLen);
        m=sum(reshape(abs(data(1:l*windowLen)),windowLen,l));
        d=diff(m);
        % figure;plot(d)

        [mx,inx]=max(d(1:l-1));
        md=mean(abs(d(1:l-1)));
        inx = max(2,inx);
        inx = min(inx,l-2);

        % Search the data set for a transition from low to high power. The max
        % needs to be 8x greater than the mean in a segment to be a transition.
        % Then trim the waveform from the start of the transition until the end.
        if mx>8*md
            a1=d(inx)-d(inx-1);
            a2=d(inx)-d(inx+1);
            if a1>a2
                startPt = inx*windowLen;
            else
                startPt = max(1,(inx-1)*windowLen);
            end
        else
            startPt = 1;
        end

        % Trim waveform
        % Messages can be from 184 bits long (including CRC) to 440 bits long.
        % There are also some ramp up bits, 24 sync bits and and an 8 bit start flag.
        % Capture enough samples to get longest message, which is the window length
        % plus 480bits*samplesPerSymbol.
        endPt = min(length(data),startPt+windowLen+480*samplesPerSymbol);
        dataSlice=data(startPt:endPt);
        aisIdx=[startPt endPt];
        % figure;plot(abs(dataSlice))

        % Coarse Frequency Correction
        Y=abs(fftshift(fft(dataSlice)));
        idx=find(Y==max(Y));
        frShift=(floor(length(dataSlice)/2)-idx)*RX.SampleRate/length(Y);
        hc=comm.PhaseFrequencyOffset('FrequencyOffset',frShift,'SampleRate',RX.SampleRate);
        dataShifted=step(hc,dataSlice);
        % plot(abs(fftshift(fft(dataShifted))))

        % Find Start and End Points
        newStart=21;
        newEnd=length(dataShifted)-20;
        m=mean(abs(dataShifted));
        idx1=find(abs(dataShifted)>m,1,'first');
        idx2=find(abs(dataShifted)>m,1,'last');
        idxStart=max(newStart,idx1);
        idxEnd=min(newEnd,idx2);
        aisSig=dataShifted(idxStart:idxEnd);

        % GMSK Filter
        rxf = filter(gx,1,aisSig);

        % Fine Frequency Correction with comm.FrequencySynchronizer
        rxfShifted = rxf;
        
        % Find max correlation to preamble
        rxAngles = step(phaseCalc,rxfShifted);
        syncCorr=zeros(length(rxAngles)-length(syncIdeal),1);
        if (length(rxAngles) > samplesPerSymbol*50 + length(syncIdeal))
            for ii=1:samplesPerSymbol*50
                syncCorr(ii)=syncIdeal'*rxAngles(ii:ii+length(syncIdeal)-1);
            end
        else
            syncCorr(1)=1;
        end
        % figure;stem(syncCorr);title('Correlation to Preamble')
        
        % Compute best sample phase for making bit decisions
        [m,idx]=max(abs(syncCorr));
        samplePhase=mod(idx,samplesPerSymbol)+floor(samplesPerSymbol/2);

        % Make bit decisions (phase change greater than pi/4 is logical 1
        abits=zeros(size(rxfShifted(samplePhase:samplesPerSymbol:end)));
        idx=find(abs(diff(step(phaseCalc,rxfShifted(samplePhase:samplesPerSymbol:end))))>pi/4);
        abits(idx)=1;

        sb=1;
        % Search the first 50 bits for the StartByte flag (0x7E)
        if length(abits)>56
            for ii=2:50
                if (sum(abits(ii:ii+5))==6 && abits(ii-1)==0 && abits(ii+6)==0 && sb==1)
                    sb=ii+7;
                end
            end
        end

        % Read the message type and route the bits to the correct decode
        % function
        msgType=0;
        if length(abits) >= sb+7
            msgType=(2.^(0:5)*abits(sb+2:sb+7));
        end

        % Follow AIS spec to unstuff after 5 consecutive 1's.  This will 
        % unstuff everything, including the end flag in the AIS message. 
        ubits=aisUnstuff(abits(sb:end));

        % Decode message based on detected message type
        % Compute the checksum, compare to the received message bits, and
        % if the checksum passes flip the bytes and decode the message.
        switch msgType
            case 1
                if length(ubits)>=184
                    checkSum = step(crcGen,ubits(1:168));
                    if isequal(checkSum(169:184),ubits(169:184))
                        flippedData=aisFlipBytes(ubits(1:184));
                        cs=aisDecodeMsg1(flippedData);
                        validCRC=1;
                    else
                        validCRC=0;
                    end
                    reset(crcGen);
                else
                    validCRC=0;
                end
            case 2
                if length(ubits)>=184
                    checkSum = step(crcGen,ubits(1:168));
                    if isequal(checkSum(169:184),ubits(169:184))
                        flippedData=aisFlipBytes(ubits(1:184));
                        cs=aisDecodeMsg1(flippedData);
                        validCRC=1;
                    else
                        validCRC=0;
                    end
                    reset(crcGen);
                else
                    validCRC=0;
                end
            case 3
                if length(ubits)>=184
                    checkSum = step(crcGen,ubits(1:168));
                    if isequal(checkSum(169:184),ubits(169:184))
                        flippedData=aisFlipBytes(ubits(1:184));
                        cs=aisDecodeMsg1(flippedData);
                        validCRC=1;
                    else
                        validCRC=0;
                    end
                    reset(crcGen);
                else
                    validCRC=0;
                end
            case 4
                if length(ubits)>=184
                    checkSum = step(crcGen,ubits(1:168));
                    if isequal(checkSum(169:184),ubits(169:184))
                        flippedData=aisFlipBytes(ubits(1:184));
                        cs=aisDecodeMsg4(flippedData);
                        validCRC=1;
                    else
                        validCRC=0;
                    end
                    reset(crcGen);
                else 
                    validCRC=0;
                end
            case 5
                if length(ubits)>=440
                    checkSum = step(crcGen,ubits(1:424));
                    if isequal(checkSum(425:440),ubits(425:440))
                        flippedData=aisFlipBytes(ubits(1:440));
                        cs=aisDecodeMsg5(flippedData);
                        validCRC=1;
                    else
                        validCRC=0;
                    end
                    reset(crcGen);
                else
                    validCRC=0;
                end
            case 18
                if length(ubits)>=184
                    checkSum = step(crcGen,ubits(1:168));
                    if isequal(checkSum(169:184),ubits(169:184))
                        flippedData=aisFlipBytes(ubits(1:184));
                        cs=aisDecodeMsg18(flippedData);
                        validCRC=1;
                    else
                        validCRC=0;
                    end
                    reset(crcGen);
                else
                    validCRC=0;
                end
            case 19
                if length(ubits)>=328
                    checkSum = step(crcGen,ubits(1:312));
                    if isequal(checkSum(313:328),ubits(313:328))
                        flippedData=aisFlipBytes(ubits(1:328));
                        cs=aisDecodeMsg19(flippedData);
                        validCRC=1;
                    else
                        validCRC=0;
                    end
                    reset(crcGen);
                else
                    validCRC=0;
                end
            case 21
                if length(ubits)>=288
                    checkSum = step(crcGen,ubits(1:272));
                    if isequal(checkSum(273:288),ubits(273:288))
                        flippedData=aisFlipBytes(ubits(1:288));
                        cs=aisDecodeMsg21(flippedData);
                        validCRC=1;
                    else
                        validCRC=0;
                    end
                    reset(crcGen);
                else
                    validCRC=0;
                end
            otherwise
                disp('Message Checksum Failed');
                validCRC=0;
        end

        % Calculate Figure Of Merit for RX
%         dist=abs(diff(unwrap(angle(rxfShifted(samplePhase+samplesPerSymbol*4:samplesPerSymbol:end)))));
%         idx=find(dist>pi/4);
%         dd1=sum((dist(idx)-pi/2).^2);
%         idx=find(dist<=pi/4);
%         dd2=sum(dist(idx).^2);
%         fom=sqrt(dd1+dd2);
        % figure;stem(dist,'r');hold on;line(1:length(dist),ones(1,length(dist))*pi/4);hold off

        % Remove signal from data set
        data=[data(1:aisIdx(1));data(aisIdx(2):end)];
        if validCRC==1
            if msgType==1 || msgType==2 || msgType==3
                if logFlag
                    fprintf(fileID,'%s  %s  %s  Altitude:0  %s  %s\n',cs{3},cs{8},cs{9}, bitsToHex(flippedData(1:184)), datestr(datetime('now')));
                end
                fprintf('%s  %s  %s  %s  %s\n',cs{3}, cs{9}, cs{8}, bitsToHex(flippedData(1:184)), datestr(datetime('now')));
            elseif msgType==5
                fprintf('%s  %s  %s  %s  %s  %s  %s\n',cs{3}, cs{6}, cs{7}, cs{8}, cs{13}, bitsToHex(flippedData(1:440)), datestr(datetime('now')));
            elseif msgType==18
                if logFlag
                    fprintf(fileID,'%s  %s  %s  Altitude:0  %s  %s\n',cs{3},cs{5},cs{6}, bitsToHex(flippedData(1:184)), datestr(datetime('now')));
                end
                fprintf('%s  %s  %s  %s  %s\n',cs{3}, cs{6}, cs{5}, bitsToHex(flippedData(1:184)), datestr(datetime('now')));
            elseif msgType==21
                if logFlag
                    fprintf(fileID,'%s  %s  %s  Altitude:0  %s  %s\n',cs{3},cs{7},cs{8}, bitsToHex(flippedData(1:288)), datestr(datetime('now')));
                end
                fprintf('%s  %s  %s  %s  %s\n',cs{3}, cs{8}, cs{7}, bitsToHex(flippedData(1:288)), datestr(datetime('now')));
            end
        end
    end
end

fclose('all');

% displayOnMap(fileID,'AIS')
