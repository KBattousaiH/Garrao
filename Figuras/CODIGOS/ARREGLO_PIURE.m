%% ARREGLO BATIMETRIA PIURE
%DATOS='canal_piure_geo.xyz';
%
load canal_piure_geo.xyz % LON LAT PROF
%
LON=canal_piure_geo(:,1);
LAT=canal_piure_geo(:,2);
Z=canal_piure_geo(:,3);
figure()
scatter3(LON,LAT,Z,[],Z)
colormap parula
caxis([-85 0])
colorbar
view(0,90)
axis tight

% xyz2nc('canal_piure_geo.xyz','Garrao',0,0);
% filename='canal_piure_geo.xyz';
% name='Garrao';
% xyz2nc(filename,name,cmin,cmax);
%
%pcolor(lon,lat,M0);shading interp; colorbar
lon_range = linspace(min(LON), max(LON), 300); % Rango de longitudes
lat_range = linspace(min(LAT), max(LAT), 300);      % Rango de latitudes
[lon, lat] = meshgrid(lon_range, lat_range);  % Malla de coordenadas X e Y

% Asignar los valores de profundidad a las coordenadas X e Y más cercanas
Prof = griddata(LON, LAT, Z, lon, lat);
figure()
pcolor(lon,lat,Prof);shading interp; colorbar
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ARREGLO GRD
start
g0='croco_grd.nc';
g1='croco_grd.nc.1';
g2='croco_grd.nc.2';
g3='croco_grd.nc.3';
%
lat0=ncread(g0,'lat_rho');
lon0=ncread(g0,'lon_rho');
h0=ncread(g0,'h');
msk0=ncread(g0,'mask_rho');
%
lat1=ncread(g1,'lat_rho');
lon1=ncread(g1,'lon_rho');
h1=ncread(g1,'h');
msk1=ncread(g1,'mask_rho');
%
lat2=ncread(g2,'lat_rho');
lon2=ncread(g2,'lon_rho');
h2=ncread(g2,'h');
msk2=ncread(g2,'mask_rho');
%
lat3=ncread(g3,'lat_rho');
lon3=ncread(g3,'lon_rho');
h3=ncread(g3,'h');
msk3=ncread(g3,'mask_rho');
msk3(msk3==0)=NaN;
%
PROF=-1*Z;
%
newh3 = griddata(LON, LAT, PROF, lon3, lat3);
%
figure()
m_proj('equidistant','lon',[min(min(lon3)) max(max(lon3))],'lat',[min(min(lat3)) max(max(lat3))]);  
m_pcolor(lon3,lat3,h3.*msk3);shading interp; colorbar
%m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',10);

figure()
m_proj('equidistant','lon',[min(min(lon3)) max(max(lon3))],'lat',[min(min(lat3)) max(max(lat3))]);  
m_pcolor(lon3,lat3,newh3.*msk3);shading interp; colorbar
%m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',10);
%
H3=h3;
pos_piure=find(~isnan(newh3));
H3(pos_piure)=newh3(pos_piure);
%
figure()
m_proj('equidistant','lon',[min(min(lon3)) max(max(lon3))],'lat',[min(min(lat3)) max(max(lat3))]);  
m_pcolor(lon3,lat3,H3);shading interp; colorbar
%m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',10);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%% ATRIBUTOS
%
clear all
start
G0='croco_grd.nc';
G1='croco_grd.nc.1';
G2='croco_grd.nc.2';
G3='croco_grd.nc.3';
% Abre el archivo NetCDF en modo de escritura
ncid = netcdf.open(G1, 'WRITE');
nuevo_valor = 'croco_grd.nc';
netcdf.putAtt(ncid, netcdf.getConstant('NC_GLOBAL'), 'parent_grid', nuevo_valor);
netcdf.close(ncid);
%
ncid = netcdf.open(G2, 'WRITE');
nuevo_valor = 'croco_grd.nc.1';
netcdf.putAtt(ncid, netcdf.getConstant('NC_GLOBAL'), 'parent_grid', nuevo_valor);
netcdf.close(ncid);
%
ncid = netcdf.open(G3, 'WRITE');
nuevo_valor = 'croco_grd.nc.2';
netcdf.putAtt(ncid, netcdf.getConstant('NC_GLOBAL'), 'parent_grid', nuevo_valor);
netcdf.close(ncid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
canal_piure='canal_piure_geo.xyz';
%scat_xyz2nc_CROCO(canal_piure)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
grid='/data4/matlab/USIPA/GARRAO/CROCO_FILES/croco_grd.nc';
grid1='/data4/matlab/USIPA/GARRAO/CROCO_FILES/croco_grd.nc.1';
grid2='/data4/matlab/USIPA/GARRAO/CROCO_FILES/croco_grd.nc.2';
grid3='/data4/matlab/USIPA/GARRAO/CROCO_FILES/croco_grd.nc.3';
%
gnc=netcdf(grid,'nowrite'); 
lon=gnc{'lon_rho'}(:); 
lat=gnc{'lat_rho'}(:);
G=gnc{'h'}(:);
close(gnc)
%
gnc1=netcdf(grid1,'nowrite'); 
lon1=gnc1{'lon_rho'}(:); 
lat1=gnc1{'lat_rho'}(:);
G1=gnc1{'h'}(:);
close(gnc1)
%
gnc2=netcdf(grid2,'nowrite'); 
lon2=gnc2{'lon_rho'}(:); 
lat2=gnc2{'lat_rho'}(:);
G2=gnc2{'h'}(:);
close(gnc2)
%
gnc3=netcdf(grid3,'nowrite'); 
lon3=gnc3{'lon_rho'}(:); 
lat3=gnc3{'lat_rho'}(:);
G3=gnc3{'h'}(:);
mask3=gnc3{'mask_rho'}(:);
close(gnc3)
mask3(mask3==0)=NaN;
%
S=min(min(lat)); N=max(max(lat)); O=min(min(lon)); E=max(max(lon));
S1=min(min(lat1)); N1=max(max(lat1)); O1=min(min(lon1)); E1=max(max(lon1));
S2=min(min(lat2)); N2=max(max(lat2)); O2=min(min(lon2)); E2=max(max(lon2));
S3=min(min(lat3)); N3=max(max(lat3)); O3=min(min(lon3)); E3=max(max(lon3));
%
addpath('/data3/matlab/Catalina/Catalina/Resultados/')
BATI_FINA='croco_grd_X-XI.nc';
ng=netcdf(BATI_FINA);
    latf=ng{'lat_rho'}(:);
    lonf=ng{'lon_rho'}(:);
    maskf=ng{'mask_rho'}(:);
    hf=ng{'h'}(:);
close(ng)
%
figure()
m_proj('equidistant','lon',[min(min(lonf)) max(max(lonf))],'lat',[min(min(latf)) max(max(latf))]);
    m_pcolor(lonf,latf,hf); shading interp;
    %m_contourf(lonf,latf,hf,[0 2 4 6 8 10 12 14 16 18 20 22],':','ShowText','on')   
    m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
    m_grid('linewi',2,'tickdir','out','fontsize',5);
    hold on; cmocean('deep'); colorbar; %caxis([10 30])

%
figure()
m_proj('equidistant','lon',[min(min(O3)) max(max(E3))],'lat',[min(min(S3)) max(max(N3))]);
    m_pcolor(lonf,latf,hf); shading interp;
    m_contourf(lonf,latf,hf,[0 2 4 6 8 10 12 14 16 18 20 22],':','ShowText','on')   
    m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
    m_grid('linewi',2,'tickdir','out','fontsize',5);
    hold on; cmocean('deep'); colorbar; caxis([10 30])
%
%% ENCONTRAR EN LA GRILLA FINA LOS DOMINIOS PARA LOS ANIDADOS Y ORDENARLOS EN XYZ
%
poslonA1=intersect(find(lonf>=min(min(lon1))),find(lonf<=max(max(lon1))));
poslatA1=intersect(find(latf>=min(min(lat1))),find(latf<=max(max(lat1))));
posA1=intersect(poslonA1,poslatA1);
xA1=lonf(posA1);
yA1=latf(posA1);
zA1=hf(posA1);
%
poslonA2=intersect(find(lonf>=min(min(lon2))),find(lonf<=max(max(lon2))));
poslatA2=intersect(find(latf>=min(min(lat2))),find(latf<=max(max(lat2))));
posA2=intersect(poslonA2,poslatA2);
xA2=lonf(posA2);
yA2=latf(posA2);
zA2=hf(posA2);
%
poslonA3=intersect(find(lonf>=min(min(lon3))),find(lonf<=max(max(lon3))));
poslatA3=intersect(find(latf>=min(min(lat3))),find(latf<=max(max(lat3))));
posA3=intersect(poslonA3,poslatA3);
xA3=lonf(posA3);
yA3=latf(posA3);
zA3=hf(posA3);
%
%figure()
%scatter3(xA1,yA1,zA1,[],zA1,'.');view(0,90)
%
figure()
scatter3(fipa2017_50x50_geo_n(:,1),fipa2017_50x50_geo_n(:,2),fipa2017_50x50_geo_n(:,3),[],fipa2017_50x50_geo_n(:,3),'.')
view(0,90)
%
%
BATI_grd1='croco_grd.nc.1.orig'; % batimetria relleno
ng=netcdf(BATI_grd1);
    latr=ng{'lat_rho'}(:);
    lonr=ng{'lon_rho'}(:);
    maskr=ng{'mask_rho'}(:);
    hr=ng{'h'}(:);
close(ng)
%
poslonA1=intersect(find(lonr>=min(min(lon1))),find(lonr<=max(max(lon1))));
poslatA1=intersect(find(latr>=min(min(lat1))),find(latr<=max(max(lat1))));
posA1=intersect(poslonA1,poslatA1);
xrA1=lonr(posA1);
yrA1=latr(posA1);
zrA1=hr(posA1);
% grd 0 
poslonA0=intersect(find(lon>=min(min(-75))),find(lon<=max(max(-73))));
poslatA0=intersect(find(lat>=min(min(-44.2))),find(lat<=max(max(-44))));
posA0=intersect(poslonA0,poslatA0);
xrA0=lon(posA0);
yrA0=lat(posA0);
zrA0=G(posA0);
%% XYZ con todos los puntos
%
% X-XI - FIPA - CANAL PIURE - ARBOLITO - A1
%
load fipa2017_50x50_geo_n.xyz
load canal_piure_geo.xyz
load arbolito_geo.xyz
X_XI=[xA1 yA1 -zA1];
B_A1r=[xrA1 yrA1 -zrA1];
B_A0r=[xrA0 yrA0 -zrA0];
%
l1=length(X_XI);
l2=length(fipa2017_50x50_geo_n);
l3=length(canal_piure_geo);
l4=length(arbolito_geo);
l5=length(B_A1r);
l6=length(B_A0r);
%
XYZ_GARRAO( 1                : l1                 , : )=X_XI;
XYZ_GARRAO( l1+1             : l1+l2              , : )=fipa2017_50x50_geo_n;
XYZ_GARRAO( l1+l2+1          : l1+l2+l3           , : )=canal_piure_geo;
XYZ_GARRAO( l1+l2+l3+1       : l1+l2+l3+l4        , : )=arbolito_geo;
XYZ_GARRAO( l1+l2+l3+l4+1    : l1+l2+l3+l4+l5     , : )=B_A1r;
XYZ_GARRAO( l1+l2+l3+l4+l5+1 : l1+l2+l3+l4+l5+l6  , : )=B_A0r;
%
ZZ=XYZ_GARRAO(:,3);
post=find(ZZ>-5);
ZZ(post)=-5;
%
figure()
scatter3(arbolito_geo(:,1),arbolito_geo(:,2),arbolito_geo(:,3),[],arbolito_geo(:,3))
colormap parula
colorbar
view(0,90)
axis tight

XYZ_GARRAO(:,3)=ZZ;
save('XYZ_GARRAO.mat','XYZ_GARRAO')
nombre_archivo = 'XYZ_GARRAO.xyz';
% Abre el archivo para escritura
fid = fopen(nombre_archivo, 'w');
% Escribe los datos en el archivo XYZ
fprintf(fid, '%f %f %f\n', XYZ_GARRAO');
% Cierra el archivo
fclose(fid);
%
scat_xyz2nc_CROCO('XYZ_GARRAO.xyz')
%


figure()
m_proj('equidistant','lon',[min(min(yy)) max(max(yy))],'lat',[min(min(xx)) max(max(xx))]);
m_pcolor(yy,xx,zz);shading interp; colorbar
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
    m_grid('linewi',2,'tickdir','out','fontsize',5);
H=ncread('PRUEBA_grd_Garrao.nc','topo');
pcolor(H');shading interp;colorbar


etp='/data2/matlab/CROCOv1p2p1/croco_tools/Topo/etopo2.nc';
%etp='/home/matlab/Gridgen/gridgen-main/reference_data/etopo1.nc';
etopo=ncread(etp,'topo');
isnans=isnan(etopo);
nanes=find(isnans==1);

%% ANIDAMIENTO
%
etopo_garrao='/data2/matlab/MOSA_BGQ/Garrao/ARREGLO_BATIMETRIA_GARRAO/PRUEBA_bati_Garrao_derecho.nc';
grd3terao='/data2/matlab/MOSA_BGQ/Terao/CROCO_FILES/croco_grd.nc.3.etopo2';
grd0='/data2/matlab/MOSA_BGQ/Garrao/ARREGLO_BATIMETRIA_GARRAO/croco_grd.nc';
grd1='/data2/matlab/MOSA_BGQ/Garrao/ARREGLO_BATIMETRIA_GARRAO/croco_grd.nc.1.batigarrao_noCUBIC';
grd2='/data2/matlab/MOSA_BGQ/Garrao/ARREGLO_BATIMETRIA_GARRAO/croco_grd.nc.2.batigarrao';
grd3='/data2/matlab/MOSA_BGQ/Garrao/ARREGLO_BATIMETRIA_GARRAO/croco_grd.nc.3.batigarrao';
%

ncdisp(etopo_garrao)
%
refinecoeff=3;
topofile=etopo_garrao;
newtopo=1;
rtarget= 0.2500;
nband=15;%[1 1 1 1];
hmin=10;
matchvolume=1;
hmax_coast=15;
n_filter_deep=2;
n_filter_final=2;
%
% parent_grd=grd0;
% child_grd=grd1;
% imin=221;
% imax=267;
% jmin=313;
% jmax=341;
%
% parent_grd=grd1;
% child_grd=grd2;
% imin=76;
% imax=116;
% jmin=42;
% jmax=84;
%
parent_grd=grd2;
child_grd=grd3;
imin=38;
imax=103;
jmin=50;
jmax=95;
%
[i1min,i1max,j1min,j1max]=nested_grid('croco_grd.nc','croco_grd.nc.1',imin,imax,jmin,jmax,...
    refinecoeff,topofile,newtopo,rtarget,nband,hmin,matchvolume,...
    hmax_coast,n_filter_deep,n_filter_final);
%
mask_parent=maskr_coarse;
h=hnew;
makr=maskrchild;
r_max=rtarget;
n_filter_deep_topo=n_filter_deep;
%
figure();pcolor(hnew);shading interp



GARRAO=ncread('/data2/matlab/MOSA_BGQ/Garrao/ARREGLO_BATIMETRIA_GARRAO/PRUEBA_bati_Garrao_derecho.nc','topo');
figure();pcolor(GARRAO');shading interp









