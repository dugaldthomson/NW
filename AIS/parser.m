%% For AIS parsed data, extract a kml file
%Need to load an AIS file in .mat format with a structure named AIS with
%fields named datetime, lat, long and mmsi
load('mergedAISwtype.mat');
summary(AIS);

%% find each unique mmsi
[~,contacts] = findgroups(AIS.mmsi); %count the number of unique AIS contacts by mmsi

for i = 1:length(contacts)
    rows = AIS.mmsi==contacts(i);
    vars = {'datetime','lat','long'};
    T = AIS(rows,vars);
    send = [juliandate(T.datetime),T.lat,T.long];
    pwr_kml_tll(num2str(contacts(i)),send)
end

function pwr_kml_tll(Name,TLL)
%%kml_tll(Name,TLL)
%
%inputs:
%   Name:  name of output file (e.g. 'AIS') (must be a text string)
%   TLL:  matrix of Time, Latitude, Longitude (time in matlab julian days)
%outputs:
%   creates one kml file in the current directory
%

%%Prep master header and footer
HEADER1=['<?xml version="1.0" encoding="UTF-8"?><kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom"><Document><open>1</open><StyleMap id="default"><Pair><key>normal</key><styleUrl>#default0</styleUrl></Pair><Pair><key>highlight</key><styleUrl>#hl</styleUrl></Pair></StyleMap><Style id="hl"><IconStyle><scale>0</scale></IconStyle></Style><Style id="default0"><IconStyle><scale>0</scale></IconStyle></Style>'];
HEADER2=['<name>' Name '</name>'];
HEADER3=['<Placemark><styleUrl>#default</styleUrl><gx:Track>'];
FOOTER='</gx:Track></Placemark></Document></kml>';

%%Create file to deposit data and write headers
fid = fopen([Name '.kml'], 'wt');
fprintf(fid, '%s \n',HEADER1);
fprintf(fid, '%s \n',HEADER2);
fprintf(fid, '%s \n',HEADER3);

%%Start loop.  Each iteration adds data for one position.
for i=1:size(TLL,1)
    disp(i) %count loop iterations
    %create XML header and footer for each dive
    % DT - offset datestr by 4419.5  - 3/10/20 - times are all off by 12
    % hrs, need to make it 4420  --  KML is 12 hours AHEAD (fast)
    TimeData=['<when>' datestr(datetime(TLL(i,1),'convertfrom','juliandate'),'yy-mm-dd')...
        'T' datestr(datetime(TLL(i,1),'convertfrom','juliandate'),'HH:MM:SS') 'Z</when>'];
%     TimeData=['<when>' datestr(TLL(i,1),'yy-mm-dd') 'T' datestr(TLL(i,1),'HH:MM:SS') 'Z</when>'];
    LocData=['<gx:coord>' num2str(TLL(i,[3])) ' ' num2str(TLL(i,[2])) ' 0</gx:coord>'];
    
    fprintf(fid, '%s', TimeData);
    fprintf(fid, '%s', LocData);    
end

%%Write XML footer and close file
fprintf(fid, '%s', FOOTER);
fclose(fid)
end

%% JUNK
%datetime(send(1,1),'convertfrom','juliandate')

% rows = AIS18.mmsi==316024641;
% vars = {'datetime','lat','long'};
% WAVE = AIS18(rows,vars);
% 
%  pwr_kml_tll('allch1-3',send)
% 
% send = [juliandate(AIS.datetime),AIS.lat,AIS.long];
% 
% 
% open
% %d = datetime(AIS.datetime,'InputFormat','yyyy-MM-dd''T''HH:mm:ss.SSSSSS');
% %d = datetime(d1,'InputFormat','yyyy-MM-dd''T''HH:mm:ss.SSSSSS');
% 
% %stats = grpstats(AIS18,'mmsi');
% 
% [g,contacts] = findgroups(AIS18.mmsi);  %count the number of unique AIS contacts by mmsi
% %[g,contacts] = findgroups(AIS.mmsi);
% 
% 
% %% create a table to send to pwr_kml_tll
% % mmsi of wave [316024641]
% rows = AIS18.mmsi==316024641;
% vars = {'datetime','lat','long'};
% WAVE = AIS18(rows,vars);
% %splitapply(@(x) {x}, WAVE{:,:}, findgroups(WAVE{:, 1}))
% 
% %% create a table with correct ('T') formatting to send to pwr_kml_tll_mine
% % mmsi of wave [316024641]
% rows = AIS18.mmsi==316024641;
% vars = {'tdate','lat','long'};
% WAVE = AIS18(rows,vars);
% T=WAVE.tdate;
% LL=WAVE(:,2:3);
% LL=table2array(LL);
% pwr_kml_tll_mine('WAVEkml',T,LL)
% 
% %splitapply(@(x) {x}, WAVE{:,:}, findgroups(WAVE{:, 1}))
% 
% WAVE.datetime = juliandate(WAVE.datetime);
% back = datetime(WAVE.datetime,'convertfrom','juliandate');
% WAVE = table2array(WAVE); 
% pwr_kml_tll('WAVEkml',WAVE)
% 
% %%split the contacts apart by date (manually) and now try again
% % the issue is with datestr in pwr_  datestr(WAVEarr(1,1),'yy-mm-dd')
% % KML wants yyyy-mm-ddThh:mm:sszzzzzz   --> the original format!!!
% WAVE1.datetime = juliandate(WAVE1.datetime);
% back = datetime(WAVE1.datetime,'convertfrom','juliandate');
% WAVE1 = table2array(WAVE1); 
% pwr_kml_tll('WAVE1',WAVE1)