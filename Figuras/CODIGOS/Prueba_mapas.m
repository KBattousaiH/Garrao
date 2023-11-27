addpath('/data4/matlab/USIPA/CMOCEAN_START/')
%
start
etopoG='PRUEBA_bati_Garrao.nc';
y=ncread(etopoG,'lat');
x=ncread(etopoG,'lon');
topo=ncread(etopoG,'topo');
[lon,lat]=meshgrid(x,y);
S=min(min(lat1)); N=max(max(lat)); O=min(min(lon)); E=max(max(lon));
%topo(topo>0)=NaN;
%
grd0='croco_grd.nc';
lon0=ncread(grd0,'lon_rho');
lat0=ncread(grd0,'lat_rho');
h0=ncread(grd0,'lat_rho');
%
S0=min(min(lat0)); N0=max(max(lat0)); O0=min(min(lon0)); E0=max(max(lon0));
%
grd1='croco_grd.nc.1.orig';
lon1=ncread(grd1,'lon_rho');
lat1=ncread(grd1,'lat_rho');
%
S1=min(min(lat1)); N1=max(max(lat1)); O1=min(min(lon1)); E1=max(max(lon1));
%
grd2='croco_grd.nc.2.orig';
lon2=ncread(grd2,'lon_rho');
lat2=ncread(grd2,'lat_rho');
%
S2=min(min(lat2)); N2=max(max(lat2)); O2=min(min(lon2)); E2=max(max(lon2));
%
grd3='croco_grd.nc.3.orig';
lon3=ncread(grd3,'lon_rho');
lat3=ncread(grd3,'lat_rho');
%
S3=min(min(lat3)); N3=max(max(lat3)); O3=min(min(lon3)); E3=max(max(lon3));

figure()
m_proj('equidistant','lon',[min(min(lon)) max(max(lon))],'lat',[min(min(lat)) max(max(lat))]);
m_pcolor(lon,lat,topo');shading interp;
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',10); % Tamaño nº coordenadas
colorbar
caxis([-400 400])
%cmocean('balance')
hold on
m_plot([O1 E1],[S1 S1],'-r','Linewidth',1)
    m_plot([O1 E1],[N1 N1],'-r','Linewidth',1)
    m_plot([O1 O1],[S1 N1],'-r','Linewidth',1)
    m_plot([E1 E1],[S1 N1],'-r','Linewidth',1)
%
figure()
pcolor(lon,lat,topo');shading interp
hold on
contourf(lon,lat,topo',[0 150 -150],':')
colorbar
%
%
figure()
m_proj('equidistant','lon',[min(min(lon)) max(max(lon))],'lat',[min(min(lat)) max(max(lat))]);
m_pcolor(lon,lat,topo');shading interp;
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',10); % Tamaño nº coordenadas
colorbar
hold on
m_plot([O E],[S S],'-r','Linewidth',1)
    m_plot([O E],[N N],'-r','Linewidth',1)
    m_plot([O O],[S N],'-r','Linewidth',1)
    m_plot([E E],[S N],'-r','Linewidth',1)
%
hold on
m_plot([O1 E1],[S1 S1],'-k','Linewidth',1)
    m_plot([O1 E1],[N1 N1],'-k','Linewidth',1)
    m_plot([O1 O1],[S1 N1],'-k','Linewidth',1)
    m_plot([E1 E1],[S1 N1],'-k','Linewidth',1)
%
hold on
m_plot([O2 E2],[S2 S2],'-k','Linewidth',1)
    m_plot([O2 E2],[N2 N2],'-k','Linewidth',1)
    m_plot([O2 O2],[S2 N2],'-k','Linewidth',1)
    m_plot([E2 E2],[S2 N2],'-k','Linewidth',1)
%
hold on
m_plot([O3 E3],[S3 S3],'-k','Linewidth',1)
    m_plot([O3 E3],[N3 N3],'-k','Linewidth',1)
    m_plot([O3 O3],[S3 N3],'-k','Linewidth',1)
    m_plot([E3 E3],[S3 N3],'-k','Linewidth',1)
