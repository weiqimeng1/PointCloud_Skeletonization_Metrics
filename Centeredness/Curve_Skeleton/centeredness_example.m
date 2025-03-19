close all,
addpath(genpath("../"));
load("saved_data.mat")
expected_sample_num=200;
% remove invalid element
vertice_valid_ind=~isnan(P.spls(:,1));
vertices_valid=P.spls(vertice_valid_ind,:);
vertice_adj_valid= P.spls_adj(vertice_valid_ind,vertice_valid_ind);
for i=1:size(vertices_valid,1)
    vertice_adj_valid(i,i)=0;
end

% curve point sampling
[sampled_points, curve_directions, sampled_point_num]=point_sampling_from_curve(vertices_valid,vertice_adj_valid,expected_sample_num);

% centeredness
centeredness_list=edge_point_centeredness(P.pts, sampled_points, curve_directions, P.diameter);

% boundedness
bdness=zeros(length(sampled_points),1);
for i=1:length(sampled_points)
    bdness(i)=boundedness(sampled_points(i,:),P.pts);
end

centeredness_list(bdness<0.7)=NaN;

%% Visualisation

figure(1),
movegui("center")
axis off;axis equal;set(gcf,'Renderer','OpenGL');view(0,90);view(3);
hold on,
showoptions.colorp=[ 0.5859    0.7617    0.4883];
scatter3(P.pts(:,1),P.pts(:,2), P.pts(:,3),2,[0 0.2235 0.3705],'filled','DisplayName','Cloud points');
alpha(0.3)

centeredness_ind=~isnan(centeredness_list);
centeredness_intensity=centeredness_list(centeredness_ind);
centeredness_intensity(centeredness_intensity<0)=0;

colormap("parula")
p1=scatter3(sampled_points(centeredness_ind,1),sampled_points(centeredness_ind,2),sampled_points(centeredness_ind,3),40,'.','CData',centeredness_intensity,'DisplayName','Colored by centereness');
p2=scatter3(sampled_points(~centeredness_ind,1),sampled_points(~centeredness_ind,2),sampled_points(~centeredness_ind,3),40,'.','magenta','DisplayName','NaN');
colorbar
legend([p1,p2],'Location','southwest');
fontsize(12,'points')
hold off