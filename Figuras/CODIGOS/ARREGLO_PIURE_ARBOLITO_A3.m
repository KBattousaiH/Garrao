%% ARREGLO PIURE ARBOLITO A3
%
addpath('/data4/matlab/USIPA/CMOCEAN_START/')
start
%
grid2='/data2/matlab/MOSA_BGQ/Garrao/ARREGLO_BATIMETRIA_GARRAO/croco_grd.nc.2.orig';
grid3='/data2/matlab/MOSA_BGQ/Garrao/ARREGLO_BATIMETRIA_GARRAO/croco_grd.nc.3.orig';
%
BATI_FINA='croco_grd_X-XI.nc';
ng=netcdf(BATI_FINA);
    latf=ng{'lat_rho'}(:);
    lonf=ng{'lon_rho'}(:);
    maskf=ng{'mask_rho'}(:);
    hf=ng{'h'}(:);
close(ng)
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
load fipa2017_50x50_geo_n.xyz
load canal_piure_geo.xyz
load arbolito_geo.xyz
X_XI=[xA2 yA2 -zA2];
%
l1=length(arbolito_geo);
l2=length(fipa2017_50x50_geo_n);
l3=length(canal_piure_geo);
%l4=length(X_XI);
%
XYZ_GARRAO_A3( 1                : l1                 , : )=arbolito_geo;
XYZ_GARRAO_A3( l1+1             : l1+l2              , : )=fipa2017_50x50_geo_n;
XYZ_GARRAO_A3( l1+l2+1          : l1+l2+l3           , : )=canal_piure_geo;
%XYZ_GARRAO_A3( l1+l2+l3+1       : l1+l2+l3+l4        , : )=X_XI;
%
ZZ=XYZ_GARRAO_A3(:,3);
post=find(ZZ>-5);
ZZ(post)=-5;
%
XYZ_GARRAO_A3(:,3)=ZZ;
%
A2poslon=find(XYZ_GARRAO_A3(:,1)>min(min(lon2)) & XYZ_GARRAO_A3(:,1)<max(max(lon2)));
A2poslat=find(XYZ_GARRAO_A3(:,2)>min(min(lat2)) & XYZ_GARRAO_A3(:,2)<max(max(lat2)));
A2pos=intersect(A2poslon,A2poslat);
%
XYZ_GARRAO_A3_corte=XYZ_GARRAO_A3(A2pos,:);
%
%
save('XYZ_GARRAO_A3.mat','XYZ_GARRAO_A3_corte')
nombre_archivo = 'XYZ_GARRAO_A3.xyz';
fid = fopen(nombre_archivo, 'w');
fprintf(fid, '%f %f %f\n', XYZ_GARRAO_A3_corte');
fclose(fid);
%
%%
%
figure()
scatter3(XYZ_GARRAO_A3_corte(:,1),XYZ_GARRAO_A3_corte(:,2),XYZ_GARRAO_A3_corte(:,3),[],XYZ_GARRAO_A3_corte(:,3))
%xlim([-73.7 -73.62])
%ylim([-44.4 -44.3])
colormap parula
colorbar
caxis([-85 0])
view(0,90)
%
%% TOPO
gncG=netcdf('Bati_Garrao_A3.nc','nowrite'); 
lonG=gncG{'lon'}(:); 
latG=gncG{'lat'}(:);
topoG=gncG{'topo'}(:);
close(gncG)
%
[lonT,latT]=meshgrid(lonG,latG);
%
figure()
m_proj('equidistant','lon',[min(min(lon3)) max(max(lonT))],'lat',[min(min(latT)) max(max(latT))]);
m_pcolor(lonT,latT,topoG);shading interp; colorbar
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',5);
caxis([-85 0])
%
figure()
m_proj('equidistant','lon',[min(min(lonT)) max(max(lonT))],'lat',[min(min(latT)) max(max(latT))]);
m_pcolor(lonT-0.0135,latT+0.003,topoG);shading interp; colorbar
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',5);
caxis([-85 0])
%
figure()
m_proj('equidistant','lon',[-73.72 -73.62],'lat',[-44.4 -44.3]);
m_pcolor(lonT-0.0135,latT+0.003,topoG);shading interp; colorbar
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',5);
caxis([-85 0])
%
figure()
scatter3(arbolito_geo(:,1),arbolito_geo(:,2),arbolito_geo(:,3),[],arbolito_geo(:,3))
colormap parula
caxis([-85 0])
colorbar
view(0,90)
axis tight
%
figure()
scatter3(canal_piure_geo(:,1),canal_piure_geo(:,2),canal_piure_geo(:,3),[],canal_piure_geo(:,3))
colormap parula
caxis([-85 0])
colorbar
view(0,90)
axis tight
%
figure()
scatter3(fipa2017_50x50_geo_n(:,1),fipa2017_50x50_geo_n(:,2),fipa2017_50x50_geo_n(:,3),[],fipa2017_50x50_geo_n(:,3))
colormap parula
caxis([-85 0])
colorbar
view(0,90)
axis tight
%
%% ARREGLOS DE POSICIÓN
%
dx=1/1080;
dy=dx;
lon_Arb=min(arbolito_geo(:,1)):dx:max(arbolito_geo(:,1));
lat_Arb=min(arbolito_geo(:,2)):dy:max(arbolito_geo(:,2));
%
lon_Can=min(canal_piure_geo(:,1)):dx:max(canal_piure_geo(:,1));
lat_Can=min(canal_piure_geo(:,2)):dy:max(canal_piure_geo(:,2));
%
lon_FIP=min(fipa2017_50x50_geo_n(:,1)):dx:max(fipa2017_50x50_geo_n(:,1));
lat_FIP=min(fipa2017_50x50_geo_n(:,2)):dy:max(fipa2017_50x50_geo_n(:,2));
%
%
[lonArb, latArb]=meshgrid(lon_Arb,lat_Arb);
[lonA,latA,TopoA]=griddata(arbolito_geo(:,1),arbolito_geo(:,2),arbolito_geo(:,3),lonArb,latArb);
%
[lonCan, latCan]=meshgrid(lon_Can,lat_Can);
[lonC,latC,TopoC]=griddata(canal_piure_geo(:,1),canal_piure_geo(:,2),canal_piure_geo(:,3),lonCan,latCan);
%
[lonFIP, latFIP]=meshgrid(lon_FIP,lat_FIP);
[lonF,latF,TopoF]=griddata(fipa2017_50x50_geo_n(:,1),fipa2017_50x50_geo_n(:,2),fipa2017_50x50_geo_n(:,3),lonFIP,latFIP);
%
%% FIGURAS
%
figure()
m_proj('equidistant','lon',[-73.72 -73.62],'lat',[-44.4 -44.3]);
m_pcolor(lonA,latA,TopoA);shading interp; colorbar
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',5);
caxis([-85 0])
%
figure()
m_proj('equidistant','lon',[-73.72 -73.62],'lat',[-44.4 -44.3]);
m_pcolor(lonC,latC,TopoC);shading interp; colorbar
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',5);
caxis([-85 0])
%
figure()
m_proj('equidistant','lon',[min(min(lonT)) max(max(lonT))],'lat',[min(min(latT)) max(max(latT))]);
m_pcolor(lonF,latF,TopoF);shading interp; colorbar
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',5);
%caxis([-85 0])
%
figure()
m_proj('equidistant','lon',[min(min(lonT)) max(max(lonT))],'lat',[min(min(latT)) max(max(latT))]);
m_pcolor(lonF-0.001,latF-0.001,TopoF);shading interp; colorbar
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',5);
%caxis([-85 0])
%
%% CORRIDO
%
XYZ_GARRAO_A3_corte_ajustelatlon(:,1)=XYZ_GARRAO_A3_corte(:,1)-0.0135;
XYZ_GARRAO_A3_corte_ajustelatlon(:,2)=XYZ_GARRAO_A3_corte(:,2)+0.003;
XYZ_GARRAO_A3_corte_ajustelatlon(:,3)=XYZ_GARRAO_A3_corte(:,3);
%
%
save('XYZ_GARRAO_A3_ajustelatlon.mat','XYZ_GARRAO_A3_corte_ajustelatlon')
nombre_archivo = 'XYZ_GARRAO_A3_ajustelatlon.xyz';
fid = fopen(nombre_archivo, 'w');
fprintf(fid, '%f %f %f\n', XYZ_GARRAO_A3_corte_ajustelatlon');
fclose(fid);
%
dx=1/1080;
dy=dx;
lon_ajuste=min(XYZ_GARRAO_A3_corte_ajustelatlon(:,1)):dx:max(XYZ_GARRAO_A3_corte_ajustelatlon(:,1));
lat_ajuste=min(XYZ_GARRAO_A3_corte_ajustelatlon(:,2)):dy:max(XYZ_GARRAO_A3_corte_ajustelatlon(:,2));
[lonajuste, latajuste]=meshgrid(lon_ajuste,lat_ajuste);
[lonAj,latAj,TopoAj]=griddata(XYZ_GARRAO_A3_corte_ajustelatlon(:,1),XYZ_GARRAO_A3_corte_ajustelatlon(:,2),XYZ_GARRAO_A3_corte_ajustelatlon(:,3),lonajuste,latajuste);
%
figure()
m_proj('equidistant','lon',[min(min(lon3)) max(max(lon3))],'lat',[min(min(lat3)) max(max(lat3))]);
m_pcolor(lonAj,latAj,TopoAj);shading interp; colorbar
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',5);
caxis([-85 0])
%
figure()
pcolor(lonAj,latAj,TopoAj);shading interp; colorbar
hold on
ylim([-44.34 -44.28])
xlim([-73.69 -73.6])
caxis([-85 0])
%
figure()
pcolor(lonAj,latAj,TopoAj);%shading interp; colorbar
hold on
contour(lonAj,latAj,TopoAj,-[5 10 15 20 23 25 27 30 32 35 37 40],':','ShowText','on'); colorbar    
ylim([-44.33 -44.3])
xlim([-73.7 -73.64])
caxis([-85 0])
%
figure()
m_proj('equidistant','lon',[-73.7 -73.64],'lat',[-44.33 -44.3]);
m_pcolor(lonAj,latAj,TopoAj);shading interp; colorbar
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',5);
caxis([-85 0])
%
%% PARCHES
TopoAj_Bati=TopoAj;
%
S1lon=find(lonAj>(-73.67-6*0.0009) & lonAj<(-73.67+9*0.0009));
S1lat=find(latAj>(-44.305-0.0009) & latAj<(-44.305+4*0.0009));
S1pos=intersect(S1lon,S1lat);
%
S2lon=find(lonAj>(-73.67-6*0.0009) & lonAj<(-73.64-3*0.0009));
S2lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305+2*0.0009));
S2pos=intersect(S2lon,S2lat);
%
TopoAj_Bati(S1pos)=-20; TopoAj_Bati(S2pos)=-20; %%%
%
S3lon=find(lonAj>(-73.67-6*0.0009) & lonAj<(-73.67+6*0.0009));
S3lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305+4*0.0009));
S3pos=intersect(S3lon,S3lat);
%
S4lon=find(lonAj>(-73.67-6*0.0009) & lonAj<(-73.67+8*0.0009));
S4lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305+3*0.0009));
S4pos=intersect(S4lon,S4lat);
%
S5lon=find(lonAj>(-73.67-6*0.0009) & lonAj<(-73.64-4*0.0009));
S5lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305+1*0.0009));
S5pos=intersect(S5lon,S5lat);
%
S6lon=find(lonAj>(-73.67-6*0.0009) & lonAj<(-73.64-2*0.0009));
S6lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305-2*0.0009));
S6pos=intersect(S6lon,S6lat);
%
TopoAj_Bati(S3pos)=-23;TopoAj_Bati(S4pos)=-23;
TopoAj_Bati(S5pos)=-23;TopoAj_Bati(S6pos)=-23; %%%
%
S7lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+5*0.0009));
S7lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305+4*0.0009));
S7pos=intersect(S7lon,S7lat);
%
S8lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+7*0.0009));
S8lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305+2*0.0009));
S8pos=intersect(S8lon,S8lat);
%
S9lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+28*0.0009));
S9lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305+1*0.0009));
S9pos=intersect(S9lon,S9lat);
%
S10lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+29*0.0009));
S10lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305-2*0.0009));
S10pos=intersect(S10lon,S10lat);
%
S11lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+31*0.0009));
S11lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305-3*0.0009));
S11pos=intersect(S11lon,S11lat);
%
S12lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+32*0.0009));
S12lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305-4*0.0009));
S12pos=intersect(S12lon,S12lat);
%
TopoAj_Bati(S7pos)=-25;TopoAj_Bati(S8pos)=-25; %%
TopoAj_Bati(S9pos)=-25;TopoAj_Bati(S10pos)=-25; %%
TopoAj_Bati(S11pos)=-25; TopoAj_Bati(S12pos)=-25; %%
%
S13lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+2*0.0009));
S13lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305+4*0.0009));
S13pos=intersect(S13lon,S13lat);
%
S14lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+6*0.0009));
S14lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305+3*0.0009));
S14pos=intersect(S14lon,S14lat);
%
S15lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+8*0.0009));
S15lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305+2*0.0009));
S15pos=intersect(S15lon,S15lat);
%
S16lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+27*0.0009));
S16lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305+0*0.0009));
S16pos=intersect(S16lon,S16lat);
%
S17lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+32*0.0009));
S17lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305-3*0.0009));
S17pos=intersect(S17lon,S17lat);
%
TopoAj_Bati(S13pos)=-27;TopoAj_Bati(S14pos)=-27; %%
TopoAj_Bati(S15pos)=-27;TopoAj_Bati(S16pos)=-27; %%
TopoAj_Bati(S17pos)=-27; %%
%
S18lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+2*0.0009));
S18lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305+4*0.0009));
S18pos=intersect(S18lon,S18lat);
%
S19lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+5*0.0009));
S19lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305+3*0.0009));
S19pos=intersect(S19lon,S19lat);
%
S20lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+8*0.0009));
S20lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305+1*0.0009));
S20pos=intersect(S20lon,S20lat);
%
S21lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+12*0.0009));
S21lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305+1*0.0009));
S21pos=intersect(S21lon,S21lat);
%
S22lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+26*0.0009));
S22lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305-0*0.0009));
S22pos=intersect(S22lon,S22lat);
%
S23lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+27*0.0009));
S23lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305-2*0.0009));
S23pos=intersect(S23lon,S23lat);
%
S24lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+31*0.0009));
S24lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305-2*0.0009));
S24pos=intersect(S24lon,S24lat);
%
TopoAj_Bati(S18pos)=-30; TopoAj_Bati(S19pos)=-30; %%
TopoAj_Bati(S20pos)=-30; TopoAj_Bati(S21pos)=-30; %%
TopoAj_Bati(S22pos)=-30; TopoAj_Bati(S23pos)=-30; %%
TopoAj_Bati(S24pos)=-30;
%
S25lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+1*0.0009));
S25lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305+4*0.0009));
S25pos=intersect(S25lon,S25lat);
%
S26lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+5*0.0009));
S26lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305+3*0.0009));
S26pos=intersect(S26lon,S26lat);
%
S27lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+6*0.0009));
S27lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305+2*0.0009));
S27pos=intersect(S27lon,S27lat);
%
S28lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+8*0.0009));
S28lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305+1*0.0009));
S28pos=intersect(S28lon,S28lat);
%
S29lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+12*0.0009));
S29lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305+0*0.0009));
S29pos=intersect(S29lon,S29lat);
%
S30lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+25*0.0009));
S30lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305-1*0.0009));
S30pos=intersect(S30lon,S30lat);
%
S31lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+26*0.0009));
S31lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305-2*0.0009));
S31pos=intersect(S31lon,S31lat);
%
S32lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+30*0.0009));
S32lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305-3*0.0009));
S32pos=intersect(S32lon,S32lat);
%
S33lon=find(lonAj>(-73.67+23*0.0009) & lonAj<(-73.67+25*0.0009));
S33lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.305-0*0.0009));
S33pos=intersect(S33lon,S33lat);
%
S34lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.67+32*0.0009));
S34lat=find(latAj>(-44.315+3*0.0009) & latAj<(-44.305-4*0.0009));
S34pos=intersect(S34lon,S34lat);
%
TopoAj_Bati(S25pos)=-35; TopoAj_Bati(S26pos)=-35; %%
TopoAj_Bati(S27pos)=-35; TopoAj_Bati(S28pos)=-35; %%
TopoAj_Bati(S29pos)=-35; TopoAj_Bati(S30pos)=-35; %%
TopoAj_Bati(S31pos)=-35; TopoAj_Bati(S32pos)=-35; %%
TopoAj_Bati(S33pos)=-35; TopoAj_Bati(S34pos)=-35; %%
%
S35lon=find(lonAj>(-73.68+4*0.0009) & lonAj<(-73.67+1*0.0009));
S35lat=find(latAj>(-44.305-1*0.0009) & latAj<(-44.305+4*0.0009));
S35pos=intersect(S35lon,S35lat);
%
S36lon=find(lonAj>(-73.68+8*0.0009) & lonAj<(-73.67+5*0.0009));
S36lat=find(latAj>(-44.305-14*0.0009) & latAj<(-44.305+2*0.0009));
S36pos=intersect(S36lon,S36lat);
%
S37lon=find(lonAj>(-73.68+8*0.0009) & lonAj<(-73.67+8*0.0009));
S37lat=find(latAj>(-44.305-14*0.0009) & latAj<(-44.305+0*0.0009));
S37pos=intersect(S37lon,S37lat);
%
S38lon=find(lonAj>(-73.68+8*0.0009) & lonAj<(-73.67+11*0.0009));
S38lat=find(latAj>(-44.305-14*0.0009) & latAj<(-44.305-1*0.0009));
S38pos=intersect(S38lon,S38lat);
%
S39lon=find(lonAj>(-73.68+8*0.0009) & lonAj<(-73.67+20*0.0009));
S39lat=find(latAj>(-44.305-14*0.0009) & latAj<(-44.305-2*0.0009));
S39pos=intersect(S39lon,S39lat);
%
S40lon=find(lonAj>(-73.68+8*0.0009) & lonAj<(-73.67+24*0.0009));
S40lat=find(latAj>(-44.305-13*0.0009) & latAj<(-44.305-2*0.0009));
S40pos=intersect(S40lon,S40lat);
%
S41lon=find(lonAj>(-73.68+8*0.0009) & lonAj<(-73.67+26*0.0009));
S41lat=find(latAj>(-44.305-12*0.0009) & latAj<(-44.305-3*0.0009));
S41pos=intersect(S41lon,S41lat);
%
S42lon=find(lonAj>(-73.68+8*0.0009) & lonAj<(-73.67+29*0.0009));
S42lat=find(latAj>(-44.305-11*0.0009) & latAj<(-44.305-4*0.0009));
S42pos=intersect(S42lon,S42lat);
%
S43lon=find(lonAj>(-73.68+8*0.0009) & lonAj<(-73.67+32*0.0009));
S43lat=find(latAj>(-44.305-8*0.0009) & latAj<(-44.305-5*0.0009));
S43pos=intersect(S43lon,S43lat);
%
S44lon=find(lonAj>(-73.68+4*0.0009) & lonAj<(-73.68+10*0.0009));
S44lat=find(latAj>(-44.305+0*0.0009) & latAj<(-44.305+4*0.0009));
S44pos=intersect(S44lon,S44lat);
%
TopoAj_Bati(S35pos)=-35; TopoAj_Bati(S36pos)=-38; %%
TopoAj_Bati(S37pos)=-38; TopoAj_Bati(S38pos)=-38; %%
TopoAj_Bati(S39pos)=-38; TopoAj_Bati(S40pos)=-38; %%
TopoAj_Bati(S41pos)=-38; TopoAj_Bati(S42pos)=-38; %%
TopoAj_Bati(S43pos)=-38; TopoAj_Bati(S44pos)=-38; %%
%
S45lon=find(lonAj>(-73.68+4*0.0009) & lonAj<(-73.68+9*0.0009));
S45lat=find(latAj>(-44.305+1*0.0009) & latAj<(-44.305+4*0.0009));
S45pos=intersect(S45lon,S45lat);
%
S46lon=find(lonAj>(-73.68+2*0.0009) & lonAj<(-73.68+11*0.0009));
S46lat=find(latAj>(-44.305+1*0.0009) & latAj<(-44.305+3*0.0009));
S46pos=intersect(S46lon,S46lat);
%
S47lon=find(lonAj>(-73.68+8*0.0009) & lonAj<(-73.68+15*0.0009));
S47lat=find(latAj>(-44.305+5*0.0009) & latAj<(-44.305+1*0.0009));
S47pos=intersect(S47lon,S47lat);
%
S48lon=find(lonAj>(-73.68+10*0.0009) & lonAj<(-73.68+15*0.0009));
S48lat=find(latAj>(-44.305-2*0.0009) & latAj<(-44.305+2*0.0009));
S48pos=intersect(S48lon,S48lat);
%
S49lon=find(lonAj>(-73.68+15*0.0009) & lonAj<(-73.68+17*0.0009));
S49lat=find(latAj>(-44.305-2*0.0009) & latAj<(-44.305-0*0.0009));
S49pos=intersect(S49lon,S49lat);
%
S50lon=find(lonAj>(-73.68+12*0.0009) & lonAj<(-73.68+16*0.0009));
S50lat=find(latAj>(-44.305-8*0.0009) & latAj<(-44.305-2*0.0009));
S50pos=intersect(S50lon,S50lat);
%
S51lon=find(lonAj>(-73.68+14*0.0009) & lonAj<(-73.68+19*0.0009));
S51lat=find(latAj>(-44.305-8*0.0009) & latAj<(-44.305-4*0.0009));
S51pos=intersect(S51lon,S51lat);
%
S52lon=find(lonAj>(-73.68+17*0.0009) & lonAj<(-73.68+21*0.0009));
S52lat=find(latAj>(-44.305-10*0.0009) & latAj<(-44.305-5*0.0009));
S52pos=intersect(S52lon,S52lat);
%
S53lon=find(lonAj>(-73.68+24*0.0009) & lonAj<(-73.68+28*0.0009));
S53lat=find(latAj>(-44.305-11*0.0009) & latAj<(-44.305-4*0.0009));
S53pos=intersect(S53lon,S53lat);
%
S54lon=find(lonAj>(-73.68+23*0.0009) & lonAj<(-73.68+31*0.0009));
S54lat=find(latAj>(-44.305-10*0.0009) & latAj<(-44.305-5*0.0009));
S54pos=intersect(S54lon,S54lat);
%
S55lon=find(lonAj>(-73.68+23*0.0009) & lonAj<(-73.68+34*0.0009));
S55lat=find(latAj>(-44.305-9*0.0009) & latAj<(-44.305-5*0.0009));
S55pos=intersect(S55lon,S55lat);
%
S56lon=find(lonAj>(-73.68+23*0.0009) & lonAj<(-73.68+37*0.0009));
S56lat=find(latAj>(-44.305-8*0.0009) & latAj<(-44.305-6*0.0009));
S56pos=intersect(S56lon,S56lat);
%
TopoAj_Bati(S45pos)=-40; TopoAj_Bati(S46pos)=-40; %%
TopoAj_Bati(S47pos)=-40; TopoAj_Bati(S48pos)=-40; %%
TopoAj_Bati(S49pos)=-40; TopoAj_Bati(S50pos)=-40; %%
TopoAj_Bati(S51pos)=-40; TopoAj_Bati(S52pos)=-40; %%
TopoAj_Bati(S53pos)=-40; TopoAj_Bati(S54pos)=-40; %%
TopoAj_Bati(S55pos)=-40; TopoAj_Bati(S56pos)=-40; %%
%
S57lon=find(lonAj>(-73.68+25*0.0009) & lonAj<(-73.68+32*0.0009));
S57lat=find(latAj>(-44.305-8*0.0009) & latAj<(-44.305-6*0.0009));
S57pos=intersect(S57lon,S57lat);
%
S58lon=find(lonAj>(-73.68+25*0.0009) & lonAj<(-73.68+30*0.0009));
S58lat=find(latAj>(-44.305-9*0.0009) & latAj<(-44.305-6*0.0009));
S58pos=intersect(S58lon,S58lat);
%
S59lon=find(lonAj>(-73.68+24*0.0009) & lonAj<(-73.68+27*0.0009));
S59lat=find(latAj>(-44.305-9*0.0009) & latAj<(-44.305-5*0.0009));
S59pos=intersect(S59lon,S59lat);
%
TopoAj_Bati(S57pos)=-45; TopoAj_Bati(S58pos)=-45; %%
TopoAj_Bati(S59pos)=-45;
%
S60lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.68+8*0.0009));
S60lat=find(latAj>(-44.305-11*0.0009) & latAj<(-44.305-1*0.0009));
S60pos=intersect(S60lon,S60lat);
%
S61lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.68+10*0.0009));
S61lat=find(latAj>(-44.305-11*0.0009) & latAj<(-44.305-4*0.0009));
S61pos=intersect(S61lon,S61lat);
%
TopoAj_Bati(S60pos)=-35; TopoAj_Bati(S61pos)=-35; %%
%
S62lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.68+7*0.0009));
S62lat=find(latAj>(-44.305-13*0.0009) & latAj<(-44.305-1*0.0009));
S62pos=intersect(S62lon,S62lat);
%
S63lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.68+8*0.0009));
S63lat=find(latAj>(-44.305-11*0.0009) & latAj<(-44.305-3*0.0009));
S63pos=intersect(S63lon,S63lat);
%
S64lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.68+9*0.0009));
S64lat=find(latAj>(-44.305-9*0.0009) & latAj<(-44.305-4*0.0009));
S64pos=intersect(S64lon,S64lat);
%
S65lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.68+10*0.0009));
S65lat=find(latAj>(-44.305-6*0.0009) & latAj<(-44.305-4*0.0009));
S65pos=intersect(S65lon,S65lat);
%
TopoAj_Bati(S62pos)=-30; TopoAj_Bati(S63pos)=-30; %%
TopoAj_Bati(S64pos)=-30; TopoAj_Bati(S65pos)=-30; %%
%
S66lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.68+7*0.0009));
S66lat=find(latAj>(-44.305-12*0.0009) & latAj<(-44.305-2*0.0009));
S66pos=intersect(S66lon,S66lat);
%
S67lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.68+8*0.0009));
S67lat=find(latAj>(-44.305-12*0.0009) & latAj<(-44.305-4*0.0009));
S67pos=intersect(S67lon,S67lat);
%
S68lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.68+9*0.0009));
S68lat=find(latAj>(-44.305-8*0.0009) & latAj<(-44.305-5*0.0009));
S68pos=intersect(S68lon,S68lat);
%
TopoAj_Bati(S66pos)=-25; TopoAj_Bati(S67pos)=-25; %%
TopoAj_Bati(S68pos)=-25; %%
%
S69lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.68+6*0.0009));
S69lat=find(latAj>(-44.305-10*0.0009) & latAj<(-44.305-3*0.0009));
S69pos=intersect(S69lon,S69lat);
%
TopoAj_Bati(S69pos)=-20; %TopoAj_Bati(S67pos)=-25; %%
%
S70lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.68+12*0.0009));
S70lat=find(latAj>(-44.305-20*0.0009) & latAj<(-44.305-6*0.0009));
S70pos=intersect(S70lon,S70lat);
%
S71lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.68+13*0.0009));
S71lat=find(latAj>(-44.305-12*0.0009) & latAj<(-44.305-8*0.0009));
S71pos=intersect(S71lon,S71lat);
%
%TopoAj_Bati(S70pos)=-50; 
%TopoAj_Bati(S71pos)=-30; %%
%
S72lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.68+9*0.0009));
S72lat=find(latAj>(-44.305-9*0.0009) & latAj<(-44.305-6*0.0009));
S72pos=intersect(S72lon,S72lat);
%
S73lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.68+11*0.0009));
S73lat=find(latAj>(-44.305-9*0.0009) & latAj<(-44.305-8*0.0009));
S73pos=intersect(S73lon,S73lat);
%
S74lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.68+11*0.0009));
S74lat=find(latAj>(-44.305-9*0.0009) & latAj<(-44.305-9*0.0009));
S74pos=intersect(S74lon,S74lat);
%
TopoAj_Bati(S72pos)=-25; TopoAj_Bati(S73pos)=-25; %%
TopoAj_Bati(S74pos)=-25;
%
S75lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.68+10*0.0009));
S75lat=find(latAj>(-44.305-11*0.0009) & latAj<(-44.305-6*0.0009));
S75pos=intersect(S75lon,S75lat);
%
S76lon=find(lonAj>(-73.68+7*0.0009) & lonAj<(-73.68+11*0.0009));
S76lat=find(latAj>(-44.305-11*0.0009) & latAj<(-44.305-8*0.0009));
S76pos=intersect(S76lon,S76lat);
%
TopoAj_Bati(S75pos)=-25; TopoAj_Bati(S76pos)=-25;%%
%
S77lon=find(lonAj>(-73.68+5*0.0009) & lonAj<(-73.68+8*0.0009));
S77lat=find(latAj>(-44.305-10*0.0009) & latAj<(-44.305-6*0.0009));
S77pos=intersect(S77lon,S77lat);
%
TopoAj_Bati(S77pos)=-20; 
%
S78lon=find(lonAj>(-73.64-5*0.0009) & lonAj<(-73.64-3*0.0009));
S78lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.315-1*0.0009));
S78pos=intersect(S78lon,S78lat);
%
S79lon=find(lonAj>(-73.64-6*0.0009) & lonAj<(-73.64-4*0.0009));
S79lat=find(latAj>(-44.315-3*0.0009) & latAj<(-44.315-2*0.0009));
S79pos=intersect(S79lon,S79lat);
%
TopoAj_Bati(S78pos)=-30; TopoAj_Bati(S79pos)=-27; 
%
figure()
pcolor(lonAj,latAj,TopoAj_Bati);%shading interp; colorbar
hold on
contour(lonAj,latAj,TopoAj_Bati,-[5 10 15 20 23 25 27 30 32 35 37 40],':','ShowText','on'); colorbar    
ylim([-44.33 -44.3])
xlim([-73.7 -73.64])
caxis([-85 0])
%
figure()
m_proj('equidistant','lon',[-73.7 -73.64],'lat',[-44.33 -44.3]);
m_pcolor(lonAj,latAj,TopoAj_Bati);shading interp; colorbar
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',5);
caxis([-85 0])
%
figure()
m_proj('equidistant','lon',[min(min(lon3)) max(max(lon3))],'lat',[min(min(lat3)) max(max(lat3))]);
m_pcolor(lonAj,latAj,TopoAj_Bati);shading interp; colorbar
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',5);
caxis([-85 0])
%
figure()
m_proj('equidistant','lon',[min(min(lon3)) max(max(lon3))],'lat',[min(min(lat3)) max(max(lat3))]);
m_pcolor(lonAj,latAj,TopoAj);shading interp; colorbar
m_gshhs_f('patch',[.7 .7 .7],'EdgeColor','k')
m_grid('linewi',2,'tickdir','out','fontsize',5);
caxis([-85 0])
%
figure()
pcolor(lonAj,latAj,TopoAj);%shading interp; colorbar
hold on
contour(lonAj,latAj,TopoAj,-[5 10 15 20 23 25 27 30 32 35 37 40],':','ShowText','on'); colorbar    
ylim([-44.33 -44.3])
xlim([-73.7 -73.64])
caxis([-85 0])
%
scat_xyz2nc_CROCO('XYZ_GARRAO_A3.xyz')










