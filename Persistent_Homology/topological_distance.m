function [bottleneck_dist, wasserstein_dist, d1,d2]=topological_distance(pts,cpts)
npts=size(pts,1);
%% Calculate persistence homology
[~,Rips_simplex_tree1]=persistence_pattern(pts);
[~,Rips_simplex_tree2]=persistence_pattern(cpts);

%% Get H_0 features
diag1 = Rips_simplex_tree1.persistence_intervals_in_dimension(0);
diag2 = Rips_simplex_tree2.persistence_intervals_in_dimension(0);

%% Max_dist
KDT=KDTreeSearcher(pts);
[~,dist]=knnsearch(KDT,pts,'K',2);
pv = prctile(dist(:,2),99); % quantile

%%
d1 = double(diag1);
d2 = double(diag2);

lifespan=d1(:,2)-d1(:,1);
selected_ind=find(lifespan>pv);
if length(selected_ind)/npts<0.05
    selected_ind=round(0.95*npts):npts;
end

bottleneck_dist = py.gudhi.hera.bottleneck_distance(d1(selected_ind,:), d2(selected_ind,:));
wasserstein_dist = py.gudhi.hera.wasserstein_distance(d1(selected_ind,:), d2(selected_ind,:))./length(selected_ind);
end