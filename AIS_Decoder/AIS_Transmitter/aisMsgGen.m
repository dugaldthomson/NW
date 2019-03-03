function aisWF = aisMsgGen(samplesPerSymbol)
% Generate AIS messages from captured data file

% Copyright 2016, The MathWorks, Inc.

% Set up message contents, including ramp, startFlag, endFlag and training
% sequence
% ramp=false(1,8);
tr1=logical([1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0]);
tr0=~tr1;
startFlag=logical([0 1 1 1 1 1 1 0]);
endFlag=logical([0 1 1 1 1 1 1 0]);
% trail=false(1,40);

% Read in data file of AIS messages
[filename,pathname] = uigetfile('*.txt')
fileID=fopen(strcat(pathname,'\',filename));

sourceData = textscan(fileID,'%s %s %s %s %s %s %s');
msgs=char(sourceData{5})

% Messages need to be same length, so only 184 bit messages work here
sz=size(msgs);

% Convert msg characters to bits
msgBits = logical(zeros(sz(1),4*sz(2)));
for ii=1:sz(1)
    for jj=1:sz(2)
        decNum = hex2dec(msgs(ii,jj));
        msgBits(ii,(jj-1)*4+1:jj*4) = logical(fliplr(de2bi(decNum,4)));
    end
end

% Init GMSK Modulator
% samplesPerSymbol = 24;

% Set up GMSK Modulator
mod=comm.GMSKModulator;
mod.BandwidthTimeProduct=.3;
mod.SamplesPerSymbol=samplesPerSymbol;
mod.BitInput=true
mod.PulseLength=3;
mod.SymbolPrehistory=[1 -1];

% Set up large matrix for storing message bits.  Need extra capacity beyond
% the message length for stuffing 0's into the message.
bitstream=false(sz(1),length(startFlag)+length(tr1)+length(endFlag)+sz(2)*4 + 100);
maxMsgLength = sz(2)*4;
for jj=1:sz(1)
    % Do the bit reversal and bit stuffing for each message
    flippedBits = aisFlipBytes(msgBits(jj,:));
    stuffedBits = aisStuffZeros(flippedBits);
    % Keep track of max length to trim bitstream matrix when done with 
    % all messages
    fullMsg=[tr1 startFlag stuffedBits' endFlag];
    sz = length(fullMsg);
    if sz > maxMsgLength
        maxMsgLength = sz;
    end
    
    % Build entire message and apply NRZI encoding
    bitstream(jj,1:length(fullMsg))=fullMsg;
    for ii=2:length(bitstream(jj,:))
        if bitstream(jj,ii)==1
            bitstream(jj,ii)=bitstream(jj,ii-1);
        else
            bitstream(jj,ii)=~bitstream(jj,ii-1);
        end
    end
end

% Trim bitstream matrix to max message length
bitstream = bitstream(:,1:maxMsgLength);
sz=size(bitstream);

% Build GMSK waveform
aisWF=zeros(sz(1),sz(2)*samplesPerSymbol + samplesPerSymbol*2);
for ii=1:sz(1)
    wfOut = step(mod,bitstream(ii,:)').';
    aisWF(ii,:) = [randn(1,samplesPerSymbol)*1e-3 wfOut randn(1,samplesPerSymbol)*1e-3];
end

% scatterplot(aisWF(1,:));title('Transmit Signal')
% figure;stem(unwrap(angle(aisWF(1,:))));title('Phase Change for GMSK')


