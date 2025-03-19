%%
close all
Alpha_transparency_results=0.2; % 0.1
Alpha_skeleton=0.3; % 0.5
pts_size=100;
vert_size=400;
% load("saved_results.mat")
%% Visualise skeleton
f1=figure(1);
movegui('northeast');set(gcf,'Renderer','OpenGL'); view3d rot;set(gcf,'color','white');
axis vis3d; hold on; axis off;axis equal; 
h1 = scatter3(P.pts(:,1),P.pts(:,2), P.pts(:,3),2,[0 0.2235 0.3705],'filled');
alpha(Alpha_skeleton)
h2 = scatter3(P.cpts(:,1),P.cpts(:,2), P.cpts(:,3),10,[0.8500 0.3250 0.0980],'filled');
hold off

showoptions.colorp=[0.9961    0.7422    0.4766];showoptions.colore=[0 0.2235 0.3705];
showoptions.sizep=400;showoptions.sizee=4;
f2=figure(2);
movegui('northeast');set(gcf,'Renderer','OpenGL'); view3d rot;set(gcf,'color','white');
axis vis3d; hold on; axis off;axis equal; 
scatter3(P.pts(:,1),P.pts(:,2), P.pts(:,3),2,[0 0.2235 0.3705],'filled');
alpha(Alpha_skeleton)
plot_skeleton(P.spls, P.spls_adj, showoptions);
hold off

%% Visualise persistence
f3=figure(3);
set(f3, 'Position', [100, 100, 600, 800]);
% percentage of persistence bars to be shown
Quantile_ratio=0.98;
q_ind=round(P.npts*Quantile_ratio);
x=[1:(P.npts-q_ind),q_ind:P.npts];
y=[-d1(x,2)';d2(x,2)'];
B1=barh(x,y,'stacked'); 
B1(1).FaceColor=[0 0.2235 0.3705]; B1(2).FaceColor=[0.8500 0.3250 0.0980];
% ytick(0:20:P.npts)
% legend("Original shape","Skeletal shape","Location","southeast");
truncAxis('Y',[(P.npts-q_ind),q_ind])
fontsize(15,"points")
title("d_B="+num2str(bottleneck_dist,3)+" ,d_{Wp}="+num2str(wasserstein_dist,3),FontSize=30)

%% Visulaise boundedness
f4=figure(4);
movegui('northeast');set(gcf,'Renderer','OpenGL'); view3d rot;set(gcf,'color','white');
axis vis3d; hold on; axis off;axis equal; 
p1=scatter3(P.pts(:,1), P.pts(:,2), P.pts(:,3), 2, [0 0.2235 0.3705], 'filled', 'DisplayName', 'Cloud points');
alpha(Alpha_transparency_results);

colormap("parula");
clim([0 1]); 
% colorbar
p2=scatter3(P.cpts(:,1), P.cpts(:,2), P.cpts(:,3), pts_size, '.', 'CData', boundness_sps_pts, 'DisplayName', 'Colored by boundedness');
hold off;
% legend(p2,'Location','northeast');
fontsize(15,'points')
hold off;

f5=figure(5);
movegui('northeast');set(gcf,'Renderer','OpenGL'); view3d rot;set(gcf,'color','white');
axis vis3d; hold on; axis off;axis equal; 
showoptions.colorp=[ 0.5859    0.7617    0.4883];
% plot_connectivity(refined_vertices, refined_adj, showoptions.sizee, showoptions.colore);
p3=scatter3(P.pts(:,1),P.pts(:,2), P.pts(:,3),2,[0 0.2235 0.3705],'filled','DisplayName','Cloud points');
alpha(Alpha_transparency_results);

colormap("parula")
p4=scatter3(sampled_points(:,1),sampled_points(:,2),sampled_points(:,3),pts_size,'.','CData',boundness_cs_pts,'DisplayName','Colored by boundedness');
% p2=scatter3(sampled_points(~bdness_ind,1),sampled_points(~bdness_ind,2),sampled_points(~bdness_ind,3),40,'.','magenta','DisplayName','NaN');
clim([0 1]); 
% colorbar
% legend([p3,p4],'Location','southwest');
fontsize(12,'points')
hold off

%% Visualise Centeredness
f6=figure(6);
movegui('northeast');set(gcf,'Renderer','OpenGL'); view3d rot;set(gcf,'color','white');
axis vis3d; hold on; axis off;axis equal; 
p5=scatter3(P.pts(:,1),P.pts(:,2), P.pts(:,3),2,[0 0.2235 0.3705],'filled','DisplayName','Cloud points');
alpha(Alpha_transparency_results);


colormap("parula")
p6=scatter3(P.cpts(:,1),P.cpts(:,2),P.cpts(:,3),pts_size,'.','CData',centeredness_list_sps_pts,'DisplayName','Colored by centereness');
clim([0 1]); 
% colorbar
% legend([p4,p6],'Location','southwest')
fontsize(15,'points')
hold off

f7=figure(7);
movegui('northeast');set(gcf,'Renderer','OpenGL'); view3d rot;set(gcf,'color','white');
axis vis3d; hold on; axis off;axis equal; 
showoptions.colorp=[ 0.5859    0.7617    0.4883];
scatter3(P.pts(:,1),P.pts(:,2), P.pts(:,3),2,[0 0.2235 0.3705],'filled','DisplayName','Cloud points');
alpha(Alpha_transparency_results);

colormap("parula")
p7=scatter3(sampled_points(centeredness_valid_ind,1),sampled_points(centeredness_valid_ind,2),sampled_points(centeredness_valid_ind,3),pts_size,'.','CData',abs(centeredness_list_cs_pts_valid),'DisplayName','Colored by centereness');
p8=scatter3(sampled_points(~centeredness_valid_ind,1),sampled_points(~centeredness_valid_ind,2),sampled_points(~centeredness_valid_ind,3),pts_size,'.','magenta','DisplayName','NaN');
clim([0 1]);
clim([0 1]); 
% colorbar,
% legend(p8,'Location','northeast');
fontsize(12,'points')
hold off

%% Visulise smoothness
f8=figure(8);
movegui('northeast');set(gcf,'Renderer','OpenGL'); view3d rot;set(gcf,'color','white');
axis vis3d; hold on; axis off;axis equal; 
showoptions.colorp=[ 0.5859    0.7617    0.4883];
scatter3(P.pts(:,1),P.pts(:,2), P.pts(:,3),2,[0 0.2235 0.3705],'filled','DisplayName','Cloud points');
alpha(Alpha_transparency_results);

colormap("parula")
p9=scatter3(P.cpts(:,1),P.cpts(:,2),P.cpts(:,3),pts_size,'.','CData',smoothness_list_sps_pts,'DisplayName','Colored by smoothness');
clim([0 1]); 
% colorbar
% legend([p1,p2],'Location','southwest');
fontsize(12,'points')
hold off

f9=figure(9);
movegui('northeast');set(gcf,'Renderer','OpenGL'); view3d rot;set(gcf,'color','white');
axis vis3d; hold on; axis off;axis equal; 
showoptions.colorp=[ 0.5859    0.7617    0.4883];
plot_connectivity(vertices_valid, vertice_adj_valid, showoptions.sizee, showoptions.colore);
scatter3(P.pts(:,1),P.pts(:,2), P.pts(:,3),2,[0 0.2235 0.3705],'filled','DisplayName','Cloud points');
alpha(Alpha_transparency_results);


colormap("parula")
p10=scatter3(vertices_valid(smoothness_valid_ind,1),vertices_valid(smoothness_valid_ind,2),vertices_valid(smoothness_valid_ind,3),vert_size,'.','CData',smoothness_list_valid,'DisplayName','Colored by smoothness');
p11=scatter3(vertices_valid(~smoothness_valid_ind,1),vertices_valid(~smoothness_valid_ind,2),vertices_valid(~smoothness_valid_ind,3),vert_size,'.','magenta','DisplayName','NaN');
clim([0 1]); 
% colorbar
% legend(p11,'Location','northeast');
fontsize(12,'points')
hold off

