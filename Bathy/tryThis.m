seamount = load('ArcticBathy.mat');
    lat = table2array(seamount.arcticarchipelagobathylat);
    lon = table2array(seamount.arcticarchipelagobathylong);
    worldmap([-49 -47.5],[-150 -147.5])
    scatterm(lat, lon,...
        5, seamount.arcticarchipelagobathy);
    scaleruler