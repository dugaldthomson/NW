function displayOnMap(fileName,captureType)

% Copyright 2016, The MathWorks, Inc.

% fid=fopen(fileName);
% dd=textscan(fid,'%s %s %s %s %s %s');
% 
% str=strsplit(fileName,'.');
% mapFile=strcat(char(str(1)),'.kml')
% 
if strcmp(captureType,'AIS')
    iconFile='ship2.png';
elseif strcmp(captureType,'ADSB')
    iconFile='plane1.png';
end

mapFile = text2kml(fileName,iconFile);

% for ii=1:length(dd{1})
%     str=char(dd{3}(ii));
%     str2=strsplit(str,':');
%     lat(ii,:)=str2num(char(str2(2)));
%     str=char(dd{2}(ii));
%     str2=strsplit(str,':');
%     lon(ii,:)=str2num(char(str2(2)));
%     str=char(dd{1}(ii));
%     name(ii,:)=str;
%     str2=strsplit(str,':');
%     desc(ii,:)=strcat('http://www.marinetraffic.com/en/ais/details/ships/',char(str2(2)));
%     icons(ii,:)=iconFile;
%     iconScale(ii)=.5;
% end
%     
% kmlwrite(mapFile,lat,lon,'Name',cellstr(name),'Description',cellstr(desc),'Icon',cellstr(icons),'IconScale',iconScale);

% fclose('all')
%     
winopen(mapFile)
