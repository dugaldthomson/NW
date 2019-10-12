%% concatWavCh
% Extract a single Wav channel from 48-channel array data and concatenate
clearvars

%% Set parameters
ch = 1;                                             % Which channel to extract
setDir = 'C:\Users\510PAS\PhD\Data\NW\HebSky';      % Set directory

%% Get all the file names in the directory
cd(setDir)
chFiles = dir('*.wav');                              % Find all the files in the dir
%chFiles(1) = [];                                    % Remove the '.'  (could also use dir(*.wav)
nFiles = length(chFiles);
extCh = double([]);                                  % make empty arrray 

%% Loop through the directory and extract the single channels
for iFile = 1:nFiles
    %NWFile = fullfile(setDir,chFiles.name(iFile));       % Set the audio file
    [data,fs] = audioread(chFiles(iFile).name);                   % Read in the acoustic data
    extCh = vertcat(extCh, data(:,ch));                     % Take ch from 48-ch file, concat w extCh
end
%% save the single-channel file as wav
savename = fullfile(setDir,'singleCh.wav');
audiowrite(savename,extCh,fs);
