%%
% Prerequirement: python3 gudhi
addpath(genpath("../"));
load("saved_data.mat")
close all

pts=P.pts;
cpts=P.cpts;
npts=P.npts;

%% Topological dissimilarity
[bottleneck_dist, wasserstein_dist, d1,d2]=topological_distance(pts,cpts);

disp("Bottleneck distance: ");disp(bottleneck_dist);
disp("Wasserstein distance: ");disp(wasserstein_dist);
%% Visualisation
%%%%%%%%%%%%%%%%%%%Show Barcode%%%%%%%%%%%%%%%%%%%%%%%%
figure(1),
% percentage of persistence bars to be shown
Quantile_ratio=0.98;
q_ind=round(npts*Quantile_ratio);
x=[1:(P.npts-q_ind),q_ind:P.npts];
y=[-d1(x,2)';d2(x,2)'];
B1=barh(x,y,'stacked'); 
B1(1).FaceColor=showoptions.colorp; B1(2).FaceColor=showoptions.colore;
legend("Original shape","Skeletal shape","Location","southeast");
truncAxis('Y',[(P.npts-q_ind),q_ind])
fontsize(15,"points")

%%%%%%%%%%%%%%%%%%%Show Compared Pointsets%%%%%%%%%%%%%%%%%%%%%%%%
figure(2),
movegui("center")
axis off;axis equal;set(gcf,'Renderer','OpenGL');view(3);
hold on,

p1=scatter3(P.pts(:,1),P.pts(:,2), P.pts(:,3),2,showoptions.colore,'filled','DisplayName','Original Shape');
alpha(0.3)

p2=scatter3(P.cpts(:,1),P.cpts(:,2),P.cpts(:,3),3,showoptions.colorp,'filled','DisplayName','Skeletal Shape');

legend

hold off
