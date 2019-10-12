clear all

load byShip
load arrays_lat-long

array1=table2array(array1(:,1:2));
array2=table2array(array2(:,1:2));

AIS = Heb_Sky;   %select ship of interest
AIS = sortrows(AIS,'datetime','ascend');

%% Calculate ranges along ship track
[R1, R2] = calcDist(AIS.lat, AIS.long, array1, array2);

%% Calculate TL for each window location
TL1 = 10*log(R1(:,24,1)*1000);
TL2 = 10*log(R2(:,24,1)*1000);   %for one centre hph location only

%% Plot bearing histogram of ranges
rangeRoser(R1(:,1,2), R1(:,1,1), 'legendtype', 1, 'anglenorth', 0, 'angleeast', 90, 'lablegend', 'Distance (km)')
set(gca,'FontSize',14)