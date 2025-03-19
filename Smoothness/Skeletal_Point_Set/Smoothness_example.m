addpath(genpath("../"));
load("saved_data.mat")
close all;
%%
cpts=P.cpts;
pts=P.pts;

[ ~, ~,curve_tangents] = findSkeletonPointNormals(cpts,8);
smoothness_list=point_smoothness_by_cosine(cpts,curve_tangents,12);

smoothness_list=abs(smoothness_list);
smoothness_ind=~isnan(smoothness_list);
smoothness_intensity=smoothness_list(smoothness_ind);
smoothness_intensity(smoothness_intensity<0)=0;

figure(1),
movegui("center")
axis off;axis equal;set(gcf,'Renderer','OpenGL');view(0,90);view(3);
hold on,
showoptions.colorp=[ 0.5859    0.7617    0.4883];
scatter3(pts(:,1),pts(:,2), pts(:,3),2,[0 0.2235 0.3705],'filled','DisplayName','Cloud points');
alpha(0.3)

colormap("parula")
p1=scatter3(cpts(smoothness_ind,1),cpts(smoothness_ind,2),cpts(smoothness_ind,3),40,'.','CData',smoothness_intensity,'DisplayName','Colored by centereness');
p2=scatter3(cpts(~smoothness_ind,1),cpts(~smoothness_ind,2),cpts(~smoothness_ind,3),40,'.','magenta','DisplayName','NaN');
colorbar
legend([p1,p2],'Location','southwest');
fontsize(12,'points')
hold off