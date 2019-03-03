%NW files are 16-bit floats

multi = 'UWSS_LA1_NB_OSCAN_B332_30AUG15_024142.wav';
NWFile = fullfile('D:\wav',multi);
[x,fs] = audioread(NWFile);

