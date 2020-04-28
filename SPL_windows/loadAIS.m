function AIS = loadAIS(dataYear,mmsi)
%loadAIS is a function to load the AIS information from the ship of
%interest, parse the time of interest and jetison the rest
switch dataYear
    case '2015'
        load AIS15Comb.mat AIS
    case '2019'
        load AIS19Comb.mat AIS 
end

rows = AIS.mmsi == mmsi;
AIS = AIS(rows,{'datetime' 'long' 'lat' 'cog' 'sog'});
