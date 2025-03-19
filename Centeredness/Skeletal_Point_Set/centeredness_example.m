addpath(genpath("../"));
load("saved_data.mat")
close all;
pts=P.pts;
cpts=P.cpts;
npts=P.npts;
Neighbor_ratio=0.01;
neighbor_num=round(npts*Neighbor_ratio);
% neighbor_num=50;
centeredness_list=skeletal_centeredness(pts,cpts,neighbor_num);


%%
figure(1),
movegui("center")
axis off;axis equal;set(gcf,'Renderer','OpenGL');view(0,90);view(3);
hold on,
p1=scatter3(P.pts(:,1),P.pts(:,2), P.pts(:,3),2,[0 0.2235 0.3705],'filled','DisplayName','Cloud points');
alpha(0.3)


colormap("hot")
p2=scatter3(P.cpts(:,1),P.cpts(:,2),P.cpts(:,3),20,'.','CData',centeredness_list,'DisplayName','Colored by centereness');
colorbar
legend([p1,p2],'Location','southwest')
fontsize(15,'points')
hold off

% Histogram
figure(2);
histogram(centeredness_list, 100);
fontsize(15,'points')
xlabel('Centeredness');