function [R1,R2] = calcDist(lats, longs, array1, array2)
%%  calcDist - calculates the distance and angle from an AIS contact to NW
%   array nodes
R1 = zeros(length(lats),48,2);
R2 = zeros(length(lats),48,2);
for j = 1:length(lats)  % does it need loop?
    [arc1,az1] = distance([lats(j) longs(j)],array1);  %output is arclength
    [arc2,az2] = distance([lats(j) longs(j)],array2);  %from contact to arrays
    R1(j,:,1) = deg2km(arc1);
    R2(j,:,1) = deg2km(arc2);
    R1(j,:,2) = az1;
    R2(j,:,2) = az2;
end

end

