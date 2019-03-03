function deg=ConvertDegFrac(dd, mm, ss)

% Copyright 2016, The MathWorks, Inc.

if dd>0
    deg = dd+mm/60+ss/3600;
else
    deg = dd-mm/60-ss/3600;
end

