%% Signal Analyzer
% Inspect a wav file of interest for sample rate, length, etc
sigAn = 0;  % turn on to initiate MATLAB signalAnalyzer GUI
spec = 1;   % turn on to initiate spectrogram
%% Point to file
%NWFile = fullfile('C:\Users\510PAS\PhD\Data\NW\OcEnd\20150830_AAA2\west_aaa2_20150830_094520_00_0010.wav');
% NWFile = fullfile('C:\Users\510PAS\PhD\Data\NW_2019\OcEnd\20190827_AAA2\wav\singleCh24.wav');

%NWFile = fullfile('C:\Users\510PAS\Downloads\D91_1440-1810.wav');


%% Read in file
[x,fs] = audioread(NWFile);  
info1 = audioinfo(NWFile);
whos x

%% Calculate time length of wav file
time = length(x(:,1))/fs;

%% Optional MATLAB GUI
if sigAn == 1
    signalAnalyzer
end

%% Optional Spectrogram

if spec == 1
    dur=0.5;
    winSize=round(fs*dur);
    overlap=round(winSize/2);
    fftsize=winSize;
    figure
    spectrogram(x(:,1),winSize,overlap,fftsize,fs,'yaxis')
end

%% JUNK
% multi = 'west_aaa2_20150826_165958_00_0131.wav';
% NWFile = fullfile('C:\Users\510PAS\PhD\Data\NW\HebSky',multi);  % TOAST
% single = 'LA1_30AUG15_093722_393.wav';  % STB 
% file = 'west_aaa2_20150830_093601_00_0009.wav'; %STB
% dir = 'C:\Users\510PAS\PhD\Data\NW';
% NWFile = fullfile(dir,file);  % STB