function [Sz,F] = vernierProcLean(Sz, par, G, proc, x)

%define parameters
Fc       = 505; % Bandpass filter center frequency
BW       = 10;  % Bandwidth of interest
fftLen = 100;

bwFactor = floor(par.fs/BW);
Fsd    = par.fs / bwFactor;
F      = Fc + Fsd/fftLen*(0:fftLen-1)-Fsd/2;

tic
zfft = dsp.ZoomFFT(bwFactor,Fc,par.fs,'FFTLength',fftLen);
for iEvent = 10:proc.numSpec
    for iRec=1%:par.numRec
        toc
        data = x(par.timeInt*par.fs*(iEvent-1)+1:...
            par.timeInt*par.fs*(iEvent-1)+proc.dataLengthSamples,iRec);
        proc.numSeg = floor(length(data)/proc.segLengthSamples);
        Z = zfft(reshape(data(1:proc.numSeg*proc.segLengthSamples),...
            proc.segLengthSamples,proc.numSeg));
        Z = fftshift(Z);
        Sz{iRec,1}(iEvent,:) = ...
            (sum(abs(Z).^2,2).*G{iRec}.^2)/length(Z);   %Transfer function
        if mod(iEvent,round(proc.numSpec/10))==0
            disp([num2str(round(100*iEvent/proc.numSpec)) '% done'])
        end
    end
    release(zfft)
end