%% concatWavAll
% Concatenate 10-min 48-ch wav files into a single wav
clearvars

%% Set parameters
setDir = 'C:\Users\510PAS\PhD\Data\NW\Lat\20150903_AAA2';      % Set directory

%% Get all the file names in the directory
cd(setDir)
chFiles = dir('*.wav');                              % Find all the files in the dir
nFiles = length(chFiles);
extCh = double([]);                                  % make empty arrray 

%% Loop through the directory and extract the single channels
for iFile = 1:nFiles
    %NWFile = fullfile(setDir,chFiles.name(iFile));       % Set the audio file
    [data,fs] = audioread(chFiles(iFile).name,'native');                   % Read in the acoustic data
    extCh = vertcat(extCh, data); 
%     extCh = vertcat(extCh, data(:,ch));                     % Take ch from 48-ch file, concat w extCh
end
%% save the single-channel file as wav
savename = fullfile(setDir,'\proc\allCh.wav');
audiowrite(savename,extCh,fs,'BitsPerSample',16);
