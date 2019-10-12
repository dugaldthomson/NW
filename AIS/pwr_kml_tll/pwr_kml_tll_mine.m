function pwr_kml_tll_mine(Name,T,LL)
%pwr_kml_tll(Name,TLL)
%
%inputs:
%   Name:  name of output file (e.g. 'R521-argos') (must be a text string)
%   TLL:  matrix of Time, Latitude, Longitude (time in matlab julian days)
%outputs:
%   creates one kml file in the current directory
%
%Example:
%   pwr_kml_tll('test',track(:,1:3));
%
%PWR20120704

%Prep master header and footer
HEADER1=['<?xml version="1.0" encoding="UTF-8"?><kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom"><Document><open>1</open><StyleMap id="default"><Pair><key>normal</key><styleUrl>#default0</styleUrl></Pair><Pair><key>highlight</key><styleUrl>#hl</styleUrl></Pair></StyleMap><Style id="hl"><IconStyle><scale>0</scale></IconStyle></Style><Style id="default0"><IconStyle><scale>0</scale></IconStyle></Style>'];
HEADER2=['<name>' Name '</name>'];
HEADER3=['<Placemark><styleUrl>#default</styleUrl><gx:Track>'];
FOOTER='</gx:Track></Placemark></Document></kml>';

%Create file to deposit data and write headers
fid = fopen([Name '.kml'], 'wt');
fprintf(fid, '%s \n',HEADER1);
fprintf(fid, '%s \n',HEADER2);
fprintf(fid, '%s \n',HEADER3);

%Start loop.  Each iteration adds data for one position.
for i=1:size(LL,1)
    i %count loop iterations
        
    %create XML header and footer for each dive
    TimeData=['<when>',T(i,1),'Z</when>'];
    LocData=['<gx:coord>' num2str(LL(i,[3])) ' ' num2str(LL(i,[2])) ' 0</gx:coord>'];
    
    fprintf(fid, '%s', TimeData);
    fprintf(fid, '%s', LocData);    
end

%write XML footer and close file
fprintf(fid, '%s', FOOTER);
fclose(fid)
