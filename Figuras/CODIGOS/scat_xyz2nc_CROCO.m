%function scat_xyz2nc(filename,name,cmin,cmax);
function scat_xyz2nc_CROCO(filename,lonlim,latlim,dx);

%---------------------------------------------
% cargando batimetria
%---------------------------------------------

start;
%% original
xyz_data=load(filename);
%% cambio
%xyz_data=XYZ_GARRAO_A3_corte_ajustelatlon;

x=xyz_data(:,1);
y=xyz_data(:,2);
%y=y';

z=xyz_data(:,3);


%
% Traspasando datos a matrices
%
%% origigal
%dx=1/240;
%dy=dx;
%% arrego
dx=1/1080;
dy=dx;
lon_0=min(x):dx:max(x);
lat_0=min(y):dy:max(y);
% lon_0=min(lonlim):dx:max(lonlim);
% lat_0=min(latlim):dy:max(latlim);

%[lon, lat]=meshgrid(lon_0,lat_0);
[lon, lat]=meshgrid(lon_0,lat_0);

%keyboard
[xx, yy, zz]=griddata(x,y,z,lon,lat);
%[yy, xx, zz]=griddata(y,x,z,lat,lon);

save -ascii batiti.txt zz

%
% Create NetCDF file
%

grdname=['Bati_Garrao_A3_ajustelatlon.nc'];
nw=netcdf(grdname,'clobber');

%
% Create Dimensions
%

%nw('X') = size(xx,1);
%nw('Y') = size(xx,2);
nw('lon') = size(xx,2);
nw('lat') = size(xx,1);

%
% Create variables and attributes
%

nw{'lon'}  = ncfloat('lon');
nw{'lat'}  = ncfloat('lat');
nw{'topo'} = ncfloat('lat','lon');
%nw{'topo'} = ncfloat('lon','lat');

nw{'topo'}.long_name =  ncchar('ocean depth');
nw{'topo'}.long_name =  'ocean depth';
nw{'topo'}.units = ncchar('meter');
nw{'topo'}.units = 'meter';


close(nw);

%
% Fill in the data
%

nc=netcdf(grdname,'write');
% nc{'lon'}(:)=squeeze(yy(:,1));
% nc{'lat'}(:)=squeeze(xx(1,:));
nc{'lon'}(:)=squeeze(xx(1,:));
nc{'lat'}(:)=squeeze(yy(:,1));
nc{'topo'}(:,:)=zz;

close(nc)

%  mesh(lon,lat,zz)
% hold on
% plot3(x,y,z,'o')
% hold off