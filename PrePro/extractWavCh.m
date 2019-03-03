%% Extract a single Wav channel from 48-channel array data
%NW files are 16-bit floats

%% Set parameters
ch = 1;                                         % Which channel to extract
dir = 'C:\Users\510PAS\PhD\Data\NW\HebSky';     % Set directory
multi = 'west_aaa2_20150826_165958_00_0131.wav'; % Set 48-ch file

%% Load the file of interest
NWFile = fullfile(dir,multi);  % TOAST
% single = 'LA1_30AUG15_093722_393.wav';  % STB 
% file = 'west_aaa2_20150830_093601_00_0009.wav'; %STB
% dir = 'C:\Users\510PAS\PhD\Data\NW';
% NWFile = fullfile(dir,file);  % STB

%% Read in the acoustic data using audioread
[data,fs] = audioread(NWFile);  
%[x,fs] = audioread(NWFile,'native');
info = audioinfo(NWFile);   % 32-bit, 48-ch, 600 sec
whos data
fs;

%% Take ch1 from 48-ch file
extCh = data(:,ch);
% x1 = [data1(:,1);data2(:,1);data3(:,1);data4(:,1);data5(:,1)];
% time = length(x1)/fs/60;
% disp time

%% pad the array from 16-bit to 32-bit
%x1_0 = padarray(x1,16);
%whos x1_0  
%signalAnalyzer
%time = length(x1_0)/fs/60;

%% save the single-channel file as wav
savename = fullfile(dir,'singleCh.wav');
audiowrite(savename,extCh,fs);
