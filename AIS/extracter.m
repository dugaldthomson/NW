%% Extract subset of AIS table

rows = AIS.mmsi == 309336000;
NGEx_G = AIS(rows,:);

figure; geoplot([NGEx_G.lat], [NGEx_G.long])