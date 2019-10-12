clear all

load AIS
load arrays_lat-long

%% find each unique mmsi
[~,contacts] = findgroups(AIS.mmsi); %count the number of unique AIS contacts by mmsi
% %% set filter parameters to remove outliers
% windowSize = 60;
% numMedians = 1;

for i = 1:length(contacts)
    rows = AIS.mmsi==contacts(i);
    vars = {'datetime','lat','long'};
    %vars = {'lat','long'};
    T = AIS(rows,vars);   %need to store uniquely for each contact
end 

T = sortrows(T,'datetime','ascend');
Td=table2array(T(:,2:3));
array1=table2array(array1(:,1:2));
%% calculate distances and azimuth between 
dist = zeros(length(array1),length(Td),2);
for j = 1:length(Td)
    [dT,az] = distance(Td(j,:),array1);
    dist(:,j,1) = dT;
    dist(:,j,2) = az;
end