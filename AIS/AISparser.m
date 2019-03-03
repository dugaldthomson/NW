function [outfiles] = AISparser
%% For AIS parsed data, extract a kml file
% Outputs a series of kml files in the wd named '(mmsi #)'
% Requires the AIS data pre-cleaned with columns
% 'datetime','mmsi','lat','long'
% Each AIS message type has a unique way of storing these so manually
% cleaning is probably best

%% Load the AIS file
load('AIS18.mat'); 
AIS=AIS18;
summary(AIS);

%% find each unique mmsi
[~,contacts] = findgroups(AIS.mmsi); %count the number of unique AIS contacts by mmsi
%% set filter parameters to remove outliers
windowSize = 60;
numMedians = 1;


for i = 1:length(contacts)
    rows = AIS.mmsi==contacts(i);
    vars = {'datetime','lat','long'};
    T = AIS(rows,vars);
    send = [juliandate(T.datetime),T.lat,T.long];
    pwr_kml_tll(num2str(contacts(i)),send)
end 