function captureFileOut = text2kml(varargin)

% Copyright 2016, The MathWorks, Inc.

if nargin==2
    iconFlag = true;
    captureFileIn = varargin{1};
    iconFile = varargin{2};
elseif nargin==1
    captureFileIn = varargin{1};
    iconFlag = false;
else
    disp('Error: too many input arguments\n');
end

str = strsplit(captureFileIn,'.');
nm = char(str{1});
captureFileOut = strcat(nm,'.kml');
infile = fopen(captureFileIn);
outfile = fopen(captureFileOut,'w');

fprintf(outfile,'<?xml version="1.0" encoding="utf-8"?>\n');
fprintf(outfile,'<kml xmlns="http://www.opengis.net/kml/2.2">\n');
fprintf(outfile,'<Document>\n');
fprintf(outfile,'<name>%s</name>\n',nm);


cells = textscan(infile,'%s %s %s %s %s %s %s');

for ii=1:length(cells{1})
    str=char(cells{1}(ii));
    str2=strsplit(str,':');
    type=char(str2(1));
%     ID=str2double(char(str2(2)));
    ID=char(str2(2));
    str=char(cells{2}(ii));
    str2=strsplit(str,':');
    lon=str2double(char(str2(2)));
    str=char(cells{3}(ii));
    str2=strsplit(str,':');
    lat=str2double(char(str2(2)));
    str=char(cells{4}(ii));
    str2=strsplit(str,':');
    alt=str2double(char(str2(2)));
    
    
%       <Placemark>
%          <Snippet maxLines="0"> </Snippet>
%          <description>http://www.marinetraffic.com/en/ais/details/ships/367029020</description>
%          <name>MMSI:367029020</name>
%          <Style>
%             <IconStyle>
%                <Icon>
%                   <href>C:\Applications\MATLAB\work\R2015b\RTLSDRGUI_MLCentral\ship1.png</href>
%                </Icon>
%                <scale>0.5</scale>
%             </IconStyle>
%          </Style>
%          <Point>
%             <coordinates>-71.0315,42.3626,0</coordinates>
%          </Point>
%       </Placemark>
    fprintf(outfile,'<Placemark>\n');    
    fprintf(outfile,'<Snippet maxLines="0"> </Snippet>\n');
    if strcmp(type,'MMSI')
        fprintf(outfile,'<description>http://www.marinetraffic.com/en/ais/details/ships/%d</description>\n',str2num(ID));
    elseif strcmp(type,'AircraftID')
        fprintf(outfile,'<description>http://www.flightradar24.com\nAltitude: %d </description>\n',alt);
%         fprintf(outfile,'<description></description>\n',alt);
    end
%     fprintf(outfile,'<font size=2><name>%s:%d</name></font>\n',type,ID);    
    fprintf(outfile,'<name>%s:%s</name>\n',type,ID);    
    if iconFlag
        fprintf(outfile,'<Style>\n');    
        fprintf(outfile,'<IconStyle>\n');    
        fprintf(outfile,'<Icon>\n');    
        fprintf(outfile,'<href>%s</href>\n',iconFile);    
        fprintf(outfile,'</Icon>\n');    
        fprintf(outfile,'<scale>0.5</scale>\n');    
        fprintf(outfile,'</IconStyle>\n');    
        fprintf(outfile,'</Style>\n');    
    end
    fprintf(outfile,'<Point>\n');    
    fprintf(outfile,'<coordinates>%f,%f,%f</coordinates>\n',lon,lat,alt);    
%     fprintf(outfile,'<Altitude>');
%     fprintf(outfile,'%d',alt);
%     fprintf(outfile,'</Altitude>\n');
    fprintf(outfile,'<altitudeMode>absolute</altitudeMode>\n');
    fprintf(outfile,'</Point>\n');    
    fprintf(outfile,'</Placemark>\n');    

end

fprintf(outfile,'</Document>\n');
fprintf(outfile,'</kml>\n');


% fclose('all');

% winopen(captureFileOut)
