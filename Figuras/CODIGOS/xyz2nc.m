function xyz2nc(filename,name,cmin,cmax);

%---------------------------------------------
% cargando batimetria
%---------------------------------------------

start;

xyz_data=load(filename);

 x=xyz_data(:,1);
 y=xyz_data(:,2);
 z=xyz_data(:,3);
%x=xyz_data(1,:);
%y=xyz_data(2,:);
%z=xyz_data(3,:);


%
% Traspasando datos a matrices
%

cantidad_datos_x = length(unique(x));
cantidad_datos_y = length(unique(y));

xx2 = reshape(x,cantidad_datos_y,cantidad_datos_x)';
%%xx = xx2(1,:)-360; % UCSD Database
xx = xx2(:,1);  % Etopo1 database
yy2 = reshape(y,cantidad_datos_y,cantidad_datos_x)';
yy = yy2(1,:)';
zz = reshape(z,cantidad_datos_x,cantidad_datos_y)';
zz = zz(end:-1:1,:)';
%%zz = flipud(zz);    
yy = fliplr(yy); 

 %% Needed ???
%xx(1:10)
%yy(1:10)

%maxlon=max(xx)
%minlon=min(xx)
%maxlat=max(yy)
%minlat=min(yy)
%maxzz=max(max(zz))
%minzz=min(min(zz))

%
% Create NetCDF file
%

grdname=['etopo1_' name '.nc'];
nw=netcdf(grdname,'clobber');
result = redef(nw);

%
% Create Dimensions
%

nw('lon') = size(xx,1);
nw('lat') = size(yy,1);

%
% Create variables and attributes
%

nw{'lon'}  = ncfloat('lon');
nw{'lat'}  = ncfloat('lat');
nw{'topo'} = ncfloat('lat','lon');

%nw{'topo'}.long_name =  ncchar('ocean depth');
%nw{'topo'}.long_name =  'ocean depth';
%nw{'topo'}.units = ncchar('meter');
%nw{'topo'}.units = 'meter';

result = endef(nw);

nw.title = ncchar(name);
nw.title = name;
nw.date  = ncchar(date);
nw.date  = date;
nw.type  = ncchar('ROMS topo file');
nw.type  = 'ROMS topo file';

result = close(nw);

%
% Fill in the data
%

nc=netcdf(grdname,'write');

nc{'lon'}(:)=xx;
nc{'lat'}(:)=yy;
nc{'topo'}(:,:)=zz;

close(nc)

%
% Show a plot
%

zz(zz>0)=NaN;
imagesc(xx,yy,zz);
%imagesc(xx,yy,zz,[cmin cmax]);
%%imagesc([1:length(xx)],[1:length(yy)],zz,[cmin cmax]);
%%imagesc([1:length(xx)],[1:length(yy)],zz;
set(gca,'YDir', 'normal');                      % invierte eje grafico Y

txtitle=['Bathymetry of ' name];
title(txtitle);
colorbar
