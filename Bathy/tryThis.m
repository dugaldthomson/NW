seamount = load('ArcticBathy.mat');
load coastlines
    worldmap([-49 -47.5],[-150 -147.5])
    worldmap([47 90],[-170 -130])
    lat = table2array(seamount.arcticarchipelagobathylat);
    lon = table2array(seamount.arcticarchipelagobathylong);
   geoshow(coastlat,coastlon,"DisplayType","polygon", ...
    "FaceColor",[0.9 1 0.9])
    scatterm(lat, lon,...
        5, seamount.arcticarchipelagobathy);
    scaleruler