function [bitsOut] = aisStuffZeros(bitsIn)
% aisStuffZeros takes message bits in and outputs a new bitstream with the
% zero stuffing bits inserted
% In HDLC, if a message has 5 consecutive 1's a zero should be inserted

% Copyright 2016, The MathWorks, Inc.

onesCount=0;
% bitsIn=double(bitsIn);
bitsOut=zeros(length(bitsIn)+100,1); % Possibly add 100 o's to message
bitsOutIdx=1;
for ii=1:length(bitsIn)
%     disp(bitsIn(ii));
    if bitsIn(ii)==1
        onesCount=onesCount+1;
    else
        onesCount=0;
    end
    if onesCount==5
        bitsOut(bitsOutIdx)=bitsIn(ii);
        bitsOut(bitsOutIdx+1)=0;
        bitsOutIdx=bitsOutIdx+2;
        onesCount=0;
    else
        bitsOut(bitsOutIdx)=bitsIn(ii);
        bitsOutIdx=bitsOutIdx+1;
    end
end
bitsOutEnd=max(length(bitsIn),bitsOutIdx-1);
bitsOut=bitsOut(1:bitsOutEnd);

