[data,fs] = audioread('UWSS_LA1_NB_OSCAN_B332_30AUG15_024142.wav');
Secs = length(data)/fs;
Secs = round(Secs);
dftLength = fs;
dft = dsp.FFT('FFTLengthSource','Property','FFTLength',Secs);
DFT = dft(data);