addpath(genpath("../"));
load("saved_data.mat")
close all;
vertices=P.spls;
vertex_adj=P.spls_adj;

vertice_valid_ind=~isnan(P.spls(:,1));
vertices_valid=P.spls(vertice_valid_ind,:);
vertice_adj_valid= P.spls_adj(vertice_valid_ind,vertice_valid_ind);
for i=1:size(vertices_valid,1)
    vertice_adj_valid(i,i)=0;
end

[smoothness_list, Vert_label,weights]=curve_smoothness_by_cosine(vertices_valid,vertice_adj_valid);

smoothness_valid_ind=Vert_label==2;
smoothness_list_valid=smoothness_list(smoothness_valid_ind);
weights_valid=weights(smoothness_valid_ind);
curve_smoothness=1-sum(weights_valid.*(1-smoothness_list_valid))/sum(weights);

%%
figure(1),
movegui("center")
axis off;axis equal;set(gcf,'Renderer','OpenGL');view(0,90);view(3);
hold on,
showoptions.colorp=[ 0.5859    0.7617    0.4883];
plot_connectivity(vertices_valid, vertice_adj_valid, showoptions.sizee, showoptions.colore);
scatter3(P.pts(:,1),P.pts(:,2), P.pts(:,3),2,[0 0.2235 0.3705],'filled','DisplayName','Cloud points');
alpha(0.3)


colormap("parula")
p1=scatter3(vertices_valid(smoothness_valid_ind,1),vertices_valid(smoothness_valid_ind,2),vertices_valid(smoothness_valid_ind,3),showoptions.sizep,'.','CData',smoothness_list_valid,'DisplayName','Colored by smoothness');
p2=scatter3(vertices_valid(~smoothness_valid_ind,1),vertices_valid(~smoothness_valid_ind,2),vertices_valid(~smoothness_valid_ind,3),showoptions.sizep,'.','magenta','DisplayName','NaN');
colorbar
legend([p1,p2],'Location','northwest');
fontsize(12,'points')
hold off