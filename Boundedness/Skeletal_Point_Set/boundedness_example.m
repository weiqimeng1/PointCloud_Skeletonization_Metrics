addpath(genpath("../"));
load("saved_data.mat")

%%
close all;
pts = P.pts;
cpts = P.cpts;
npts = P.npts;
boundness = points_boundedness(pts,cpts);

%% Visualization
figure(1);
movegui("center");
axis off; axis equal; set(gcf, 'Renderer', 'OpenGL'); view(0, 90); view(3);
hold on;
p1=scatter3(pts(:,1), pts(:,2), pts(:,3), 2, [0 0.2235 0.3705], 'filled', 'DisplayName', 'Cloud points');
alpha(0.3);

colormap("parula");
colorbar
p2=scatter3(cpts(:,1), cpts(:,2), cpts(:,3), 20, '.', 'CData', boundness, 'DisplayName', 'Colored by centereness');
hold off;
legend([p1,p2],'Location','southwest');
fontsize(15,'points')
hold off;

% Histogram
figure(2);
histogram(boundness, 100);
fontsize(15,'points')
% xlabel('Boundedness');