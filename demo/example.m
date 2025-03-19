addpath(genpath("../"));
clear,clc;
%% Settings
close all;  clear; clc;
options.USING_POINT_RING = GS.USING_POINT_RING;

% choose PD
PD=pcread("data/pcd_4096.ply"); 
% PD=pcdownsample(PD,"gridAverage",0.05);

Noise_ratio=0.00; % 0.05

% thereshold settings
bd_th_SPS=0.75; bd_th_CS=0.75;
cs_th_SPS=0.75; cs_th_CS=0.75;


try
    P.pts=double(PD.Location);
catch
    P.pts=PD;
end
% add_pts=close_cave(P.pts,-0.8,0.8,0.04, 0.05);
% P.pts=[P.pts;add_pts];
P.faces=[];
expected_sample_num=200;

%% 
%********************************************add noise**********************
% Define our signal - a column vector.
a=P.pts;
% Make the spread of the Gaussians be 20% of the a values
sigmas = Noise_ratio * a; % Also a column vector.
% Create the noise values that we'll add to a.
[m,n]=size(a);
randomNoise = randn(m,n) .* sigmas;
% Add noise to a to make an output column vector.
P.pts = a + randomNoise;


%% Get skeleton
P.npts = size(P.pts,1);
P.radis = ones(P.npts,1);
P.pts = GS.normalize(P.pts);
[P.bbox, P.diameter] = GS.compute_bbox(P.pts);
P.k_knn = GS.compute_k_knn(P.npts);
P.rings = compute_point_point_ring(P.pts, P.k_knn, []);
% Baseline
[P.cpts, t, initWL, WC, sl] = contraction_by_mesh_laplacian(P, options);

P.sample_radius = P.diameter*0.02;
P = rosa_lineextract(P,P.sample_radius, 1);

vertice_valid_ind=~isnan(P.spls(:,1));
vertices_valid=P.spls(vertice_valid_ind,:);
vertice_adj_valid= P.spls_adj(vertice_valid_ind,vertice_valid_ind);
for i=1:size(vertices_valid,1)
    vertice_adj_valid(i,i)=0;
end

%% Topological dissimilarity
[bottleneck_dist, wasserstein_dist, d1,d2]=topological_distance(P.pts,P.cpts);
disp("Bottleneck distance: ");disp(bottleneck_dist);
disp("Wasserstein distance: ");disp(wasserstein_dist);


%% Boundedness
% Skeletal point set
boundness_sps_pts = points_boundedness(P.pts,P.cpts);
bound_SPS=sum(boundness_sps_pts>bd_th_SPS)/length(boundness_sps_pts);
fprintf("Boundedness of skeletal point set: %f \n",bound_SPS);

% curve skeleton
% curve point sampling
[sampled_points, curve_directions, sampled_point_num]=point_sampling_from_curve(vertices_valid,vertice_adj_valid,expected_sample_num);
% boundedness
boundness_cs_pts=points_boundedness(P.pts,sampled_points);
boundedness_CS=sum(boundness_cs_pts>bd_th_CS)/length(boundness_cs_pts);
fprintf("Boundedness of curve skeleton set: %f \n",boundedness_CS);

%% Centeredness
% skeletal point set
npts=P.npts;
Neighbor_ratio=0.01;
neighbor_num=round(npts*Neighbor_ratio);
% neighbor_num=50;
centeredness_list_sps_pts=skeletal_centeredness(P.pts,P.cpts,neighbor_num);
centeredness_list_sps_pts(boundness_sps_pts<bd_th_SPS)=0;
centeredness_SPS=sum(centeredness_list_sps_pts>cs_th_SPS)/length(centeredness_list_sps_pts);
fprintf("Centeredness of skeletal point set: %f \n",centeredness_SPS);

% curve skeleton
% curve point sampling
% centeredness
centeredness_list_cs_pts=edge_point_centeredness(P.pts, sampled_points, curve_directions, P.diameter);
centeredness_list_cs_pts(boundness_cs_pts<bd_th_CS)=0;
centeredness_valid_ind=~isnan(centeredness_list_cs_pts);
centeredness_list_cs_pts_valid=centeredness_list_cs_pts(centeredness_valid_ind);
centeredness_CS=sum(centeredness_list_cs_pts_valid>cs_th_CS)/length(centeredness_list_cs_pts_valid);
fprintf("Centeredness of curve skeleton: %f \n",centeredness_CS);

%% Smoothness 
% skeletal point set
[ ~, ~,curve_tangents] = findSkeletonPointNormals(P.cpts,8);
smoothness_list_sps_pts=point_smoothness_by_cosine(P.cpts,curve_tangents,4);
Smoothness_SPS=mean(smoothness_list_sps_pts);
fprintf("Smoothness of skeletal point set: %f \n",Smoothness_SPS);

% curve skeleton
[smoothness_list_cs_pts, Vert_label,weights]=curve_smoothness_by_cosine(vertices_valid,vertice_adj_valid);
smoothness_valid_ind=Vert_label==2;
smoothness_list_valid=smoothness_list_cs_pts(smoothness_valid_ind);
weights_valid=weights(smoothness_valid_ind);
smoothness_CS=1-sum(weights_valid.*(1-smoothness_list_valid))/sum(weights);
fprintf("Smoothness of curve skeleton: %f \n",smoothness_CS);