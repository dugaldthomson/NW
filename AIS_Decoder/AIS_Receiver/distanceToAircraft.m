function [miles,az] = distanceToAircraft(vehicleLoc,rxLoc)

% Copyright 2016, The MathWorks, Inc.

% rxLoc = [42.3;-71.3504];  % Location of TMW HQ

% Usage Example
% myLoc=[ConvertDegFrac(42,21,46.51);ConvertDegFrac(-71,2,13.85)]
% shipLoc=[ConvertDegFrac(42,21,21.93);ConvertDegFrac(-71,2,57.05)]
% [y,az]=distanceToAircraft(shipLoc,myLoc)

[y,az]=distance(rxLoc(1),rxLoc(2),vehicleLoc(1),vehicleLoc(2));
miles = y*60*6080/5280;
fprintf('Distance to aircraft : %f  miles\n',miles)
fprintf('Azimuth of aircraft : %f  degrees\n',az)
