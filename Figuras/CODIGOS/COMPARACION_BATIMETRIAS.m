%% COMPARAR BATIMETRIAS
%
% DATOS(xyz)  DATOS(griddata)
% GRD(etopo2) GRD(garrao)
addpath('/data4/matlab/USIPA/CMOCEAN_START/')
start
%
% Mejoras Garrao
load XYZ_GARRAO.mat
%
% Etopo2 Garrao 
etopo_garrao='PRUEBA_bati_Garrao_derecho.nc';
etopoGarrao=ncread(etopo_garrao,'topo')*(-1);
lat_Garrao=ncread(etopo_garrao,'lat');
lon_Garrao=ncread(etopo_garrao,'lon');
[lonGarrao , latGarrao]=meshgrid(lon_Garrao,lat_Garrao);
%
% GRD CROCO
GRD_CROCO='croco_grd.nc.1.orig';
grdCroco=ncread(GRD_CROCO,'h');
latCroco=ncread(GRD_CROCO,'lat_rho');
lonCroco=ncread(GRD_CROCO,'lon_rho');
%
% GRD Garrao
GRD_GARRAO='croco_grd.nc.1.batigarrao_noCUBIC';
grdGARRAO=ncread(GRD_GARRAO,'h');
latGARRAO=ncread(GRD_GARRAO,'lat_rho');
lonGARRAO=ncread(GRD_GARRAO,'lon_rho');
%
Ylim=[min(min(latGARRAO)) max(max(latGARRAO))];
Xlim=[min(min(lonGARRAO)) max(max(lonGARRAO))];
rang=[min(min(XYZ_GARRAO(:,3))) max(max(XYZ_GARRAO(:,3)));...
    min(min(grdCroco)) max(max(grdCroco));...
    min(min(etopoGarrao)) max(max(etopoGarrao));...
    min(min(grdGARRAO)) max(max(grdGARRAO))];
rango=[0 300];
%
figure()
subplot(2,2,1)
scatter3(-XYZ_GARRAO(:,1),XYZ_GARRAO(:,2),XYZ_GARRAO(:,3),[],XYZ_GARRAO(:,3),'.')
colormap parula
%colorbar
view(0,90)
xlim([Xlim(1) Xlim(2)])
ylim([Ylim(1) Ylim(2)])
caxis(rango)

subplot(2,2,2)
m_proj('equidistant','lon',[min(min(Xlim)) max(max(Xlim))],'lat',[min(min(Ylim)) max(max(Ylim))]);
m_pcolor(lon_Garrao,lat_Garrao,etopoGarrao'),shading interp;
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',10); % Tamaño nº coordenadas
    hold on
%pcolor(lon_Garrao,lat_Garrao,etopoGarrao');shading interp
%xlim([Xlim(1) Xlim(2)])
%ylim([Ylim(1) Ylim(2)])
caxis(rango)

subplot(2,2,3)
m_proj('equidistant','lon',[min(min(Xlim)) max(max(Xlim))],'lat',[min(min(Ylim)) max(max(Ylim))]);
m_pcolor(lonCroco,latCroco,grdCroco);shading interp
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',10); % Tamaño nº coordenadas
caxis(rango)

%xlim([Xlim(1) Xlim(2)])
%ylim([Ylim(1) Ylim(2)])


subplot(2,2,4)
m_proj('equidistant','lon',[min(min(Xlim)) max(max(Xlim))],'lat',[min(min(Ylim)) max(max(Ylim))]);
m_pcolor(lonGARRAO,latGARRAO,grdGARRAO);shading interp
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',10); % Tamaño nº coordenadas
caxis(rango)
%xlim([Xlim(1) Xlim(2)])
%ylim([Ylim(1) Ylim(2)])

%

%% DIFF ETOPO GARRAO vs GRD GARRAO
%
lat_garraoCorte=find(lat_Garrao>=Ylim(1) & lat_Garrao<=Ylim(2));
lon_garraoCorte=find(lon_Garrao>=Xlim(1) & lon_Garrao<=Xlim(2));
Garraoetopo=etopoGarrao(lon_garraoCorte,lat_garraoCorte);
Garraolat=latGarrao(lat_garraoCorte,lon_garraoCorte);
Garraolon=lonGarrao(lat_garraoCorte,lon_garraoCorte);
%
GarraoEtopo=interp2(squeeze(Garraolon(1,:)'),squeeze(Garraolat(:,1)),Garraoetopo',lonGARRAO,latGARRAO,'cubic');

Garraogrd=interp2(lonGARRAO(:,1),latGARRAO(1,:)',grdGARRAO',Garraolon,Garraolat);%,'cubic');
Crocogrd=interp2(lonCroco(:,1),latCroco(1,:)',grdCroco',Garraolon,Garraolat);%,'cubic');

figure();pcolor(lonGARRAO,latGARRAO,GarraoEtopo);shading interp
%
f1=figure();
m_proj('equidistant','lon',[min(min(Xlim)) max(max(Xlim))],'lat',[min(min(Ylim)) max(max(Ylim))]);
m_pcolor(Garraolon,Garraolat,Garraoetopo');shading interp;cb3=colorbar('direction','reverse');
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',10); % Tamaño nº coordenadas
caxis(rango)
title('A1 Etopo Garrao')
cmocean('deep')
set(get(cb3,'title'),'string','[m]');
saveas(f1,'A1_Etopo_Garrao','png');
%
f2=figure();
m_proj('equidistant','lon',[min(min(Xlim)) max(max(Xlim))],'lat',[min(min(Ylim)) max(max(Ylim))]);
m_pcolor(Garraolon,Garraolat,Crocogrd);shading interp;cb3=colorbar('direction','reverse');
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',10); % Tamaño nº coordenadas
caxis(rango)
title('A1 GRD CROCO')
cmocean('deep')
set(get(cb3,'title'),'string','[m]');
saveas(f2,'A1_GRD_CROCO','png');
%
f3=figure();
m_proj('equidistant','lon',[min(min(Xlim)) max(max(Xlim))],'lat',[min(min(Ylim)) max(max(Ylim))]);
m_pcolor(Garraolon,Garraolat,Garraogrd);shading interp;cb3=colorbar('direction','reverse');
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',10); % Tamaño nº coordenadas
caxis(rango)
title('A1 GRD Garrao')
cmocean('deep')
set(get(cb3,'title'),'string','[m]');
saveas(f3,'A1_GRD_Garrao','png');
%
f4=figure();
m_proj('equidistant','lon',[min(min(Xlim)) max(max(Xlim))],'lat',[min(min(Ylim)) max(max(Ylim))]);
m_pcolor(Garraolon,Garraolat,Garraoetopo'-Garraogrd);shading interp;colorbar
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',10); % Tamaño nº coordenadas
caxis([-300 300])
cmocean('balance')
title('A1 Etopo-GRD Garrao')
saveas(f4,'A1_Etopo_-_GRDGarrao','png');
%
f5=figure();
m_proj('equidistant','lon',[min(min(Xlim)) max(max(Xlim))],'lat',[min(min(Ylim)) max(max(Ylim))]);
m_pcolor(Garraolon,Garraolat,Garraoetopo'-Crocogrd);shading interp;colorbar
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',10); % Tamaño nº coordenadas
caxis([-300 300])
cmocean('balance')
title('A1 Etopo-GRD CROCO')
saveas(f5,'A1_Etopo_-_GRDCROCO','png');
%
f6=figure();
m_proj('equidistant','lon',[min(min(Xlim)) max(max(Xlim))],'lat',[min(min(Ylim)) max(max(Ylim))]);
m_pcolor(Garraolon,Garraolat,Garraogrd-Crocogrd);shading interp;colorbar
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',10); % Tamaño nº coordenadas
caxis([-50 50])
cmocean('balance')
title('A1 GRD Garrao-GRD CROCO')
saveas(f6,'A1_GRDGarrao_-_GRDCROCO','png');
%







