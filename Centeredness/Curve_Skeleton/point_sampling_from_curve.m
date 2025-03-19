function [sampled_points, curve_directions, sampled_point_num]=point_sampling_from_curve(vertices,vertex_adj,expected_sample_num)

if nargin<3
    expected_sample_num=100;
end
%% Construct Graph
A=vertex_adj;
G = graph(A,'upper','OmitSelfLoops');
% v = dfsearch(G,1);

%% calculate Edge Length
X=G.Edges.EndNodes;
edge_Length_list=zeros(size(X,1),1);
Vert_label=zeros(size(vertices,1),1);
for i=1:size(X,1)
    v1=vertices(X(i,1),:); v2=vertices(X(i,2),:);
    edge_Length_list(i)=EucDist(v1,v2);
    Vert_label(X(i,1))=Vert_label(X(i,1))+1; Vert_label(X(i,2))=Vert_label(X(i,2))+1; 
end
Total_length=sum(edge_Length_list,"all");
%% sampling points evenly on the curve
point_num_of_edges=round(edge_Length_list./Total_length*expected_sample_num);
point_num_of_edges(point_num_of_edges<1)=1;
sampled_point_num=sum(point_num_of_edges,"all");
curve_directions=zeros(sampled_point_num,3);
sampled_points=zeros(sampled_point_num,3);
pt_label=true(sampled_point_num,1);
istart=1;
for i=1:size(X,1)
    v1=vertices(X(i,1),:); v2=vertices(X(i,2),:);
    numPoints=point_num_of_edges(i);
    iend=istart+numPoints-1;
    px = linspace(v1(1), v2(1), numPoints+1);
    py = linspace(v1(2), v2(2), numPoints+1);
    pz = linspace(v1(3), v2(3), numPoints+1);
    edge_points = [px', py', pz'];
    sampled_points(istart:iend,:)=edge_points(2:(numPoints+1),:);
    curve_directions(istart:iend,:)=repmat((v1-v2)./edge_Length_list(i),numPoints,1);
    if Vert_label(X(i,2))>2
        curve_directions(iend,:)=NaN;
        pt_label(iend)=false;
    elseif Vert_label(X(i,2))==2
        nlist=find(vertex_adj(X(i,2),:));
        B=vertices(nlist(1),:);
        A=vertices(X(i,2),:);
        C=vertices(nlist(2),:);
        if dot(B-A,C-A)/(norm(B-A)*norm(C-A))>-0.99 && dot(B-A,C-A)/(norm(B-A)*norm(C-A))<0.99
            [~,~,k] = circumcenter_AM(A,B,C);
            temp_vec=cross(B-A,C-A);
            curve_dir=cross(temp_vec,k);
            curve_dir=curve_dir./norm(curve_dir);
        else
            curve_dir=B-C;
            curve_dir=curve_dir./norm(curve_dir);
        end
        curve_directions(iend,:)=curve_dir;
    end

    istart=iend+1;
end

end

function d=EucDist(v1,v2)
    d=sqrt(sum((v1-v2).^2,2));
end