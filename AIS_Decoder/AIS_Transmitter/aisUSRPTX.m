% AIS USRP TX
% Works with B210 Board as TX and RTL-SDR as RX
% Set the transmit frequency on lines 11-13 of this file (make sure to use 
% a frequency in an unlicensed band like 910 MHz).

% Copyright 2016, The MathWorks, Inc.

%% Set up USRP TX
samplesPerSymbol = 24;
radio=findsdru;
TX=comm.SDRuTransmitter('Platform',radio.Platform,'SerialNum',radio.SerialNum,...
    'CenterFrequency',910e6,'Gain',60,'MasterClockRate',9600*samplesPerSymbol*32,...
    'InterpolationFactor',32,'EnableBurstMode',true,'NumFramesInBurst',1)

%% Convert recorded messages into AIS waveforms
% load('aisWF.mat');
aisWF = aisMsgGen(samplesPerSymbol);   % captureLogBoston4.txt works
sz = size(aisWF);
wfLength=sz(2);
txZeros = single(complex(zeros(wfLength,1)));
gmsk = single(aisWF.');

%% Transmit AIS Waveform with zeros in between messages
tic
for ii=1:10
    for jj=1:sz(1)
        for kk=1:10
            if kk==1
                step(TX,gmsk(:,jj));
            else
                step(TX,txZeros);
            end
        end
    end
end
toc

