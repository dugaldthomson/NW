function [BATHY, XGRID, YGRID] = gebconetcdf(FILE, Wlon, Elon, Slat, Nlat)
%[BATHY, XGRID, YGRID] = gebconetcdf(FILE, Wlon, Elon, Slat, Nlat)
%
%   This function opens a GEBCO bathymetry NetCDF file and retrieves data 
%   for a desired latitude/longitude window. Note: Be careful when 
%   selecting a very large area of the world (e.g. entire oceans) as the 
%   GEBCO data are stored as 16-bit and memory can run out quickly.
%
%   Author: Bryan C. Lougheed. Date: May 2014.
%   Written using MatLab version 2012a.
%
%   --Input parameters-----------------------------------------------------
%
%   FILE is a string specifying the location of the GEBCO bathymetry NetCDF
%   file, e.g. 'gebco_08.nc'. Both the half-minute and one-minute datasets
%   should be automatically recognised. HOWEVER, to avoid crash, it is best 
%   to use the half-minute NetCDF for the entire world, as this script is
%   optimised for that one, and GEBCO aren't particularly consistent in how
%   they design NetCDF files for different resolutions/regions.
%   
%   Wlon, Elon, Slat and Nlat are the decimal degree values of the
%   western, eastern, southern and northern limits of the desired lat/lon
%   window, whereby degrees N should be entered as positive, degrees S as
%   negative, degrees W as negative and degrees E as positive. The nearest
%   possible coordinates in the GEBCO bathymetry NetCDF file will be
%   used.
%
%   --Output data----------------------------------------------------------
%   
%   BATHY: Matrix containing the gridded elevation/bathymetry data for the
%   desired lat/lon window.
%
%   XGRID, YGRID: Matrices of same dimensions as BATHY, containing the
%   longitude (XGRID) and latitude (YGRID) coordinates for each datapoint
%   in BATHY. Coordinates are in decimal degrees and represent the
%   centre-of-pixel coordinates.
%
%   --Example--------------------------------------------------------------
%
%   Retrieve the bathymetry data for the Baltic Sea:
%
%   [BATHY XGRID YGRID] = gebconetcdf('C:\GISdata\gebco_08.nc',...
%   +10.0, +26.0, +52.00, +66.00)
%

% Open the NetCDF file
gebconc = netcdf.open(FILE, 'NOWRITE');

% Find information about the data contained within the file
west = netcdf.getVar(gebconc,0,0,1);
east = netcdf.getVar(gebconc,0,1,1);
north = netcdf.getVar(gebconc,1,1,1);
south = netcdf.getVar(gebconc,1,0,1);
resdata = netcdf.getVar(gebconc,3,0,1);

% All avaliable lat and lon coordinates in GEBCO file
cols = west+(resdata/2)  :  resdata : east-(resdata/2);
rows = north-(resdata/2) : -resdata : south+(resdata/2);
      
% find col and row indexes nearest to desired window
[~, start_col] = min(abs(cols - (Wlon+1*10e-100)));
[~, end_col] = min(abs(cols - (Elon-1*10e-100)));
[~, start_row] = min(abs(rows - (Nlat-1*10e-100)));
[~, end_row] = min(abs(rows - (Slat+1*10e-100)));

% Prep output matrix
BATHY = NaN(length(start_row:1:end_row),length(start_col:1:end_col));

% Read out data row by row
output_row = 0;
for i = start_row:1:end_row;

    start_index = ((i-1)*length(cols)) + start_col - 1; %subtract one (zero based indexing in NetCDF)

    count = length(start_col:1:end_col);

    row_slice = netcdf.getVar(gebconc,5,start_index,count);

    output_row = output_row+1;
    BATHY(output_row,:) = row_slice(:,:);
end

% Close the NetCDF file
netcdf.close(gebconc);

% Make meshgrid
[XGRID YGRID] = meshgrid( cols(start_col):resdata:cols(end_col) , rows(start_row):-resdata:rows(end_row) );

end
