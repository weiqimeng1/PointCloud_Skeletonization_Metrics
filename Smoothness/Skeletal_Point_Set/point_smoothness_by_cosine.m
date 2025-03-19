function [smoothness_list]=point_smoothness_by_cosine(cpts,tangents, numNeighbours)
if(nargin < 2)
    numNeighbours = 9;
end
%% Construct KNN tree for searching
%create kdtree
kdtreeobj = KDTreeSearcher(cpts,'distance','euclidean');

%get nearest neighbours
neighbours = knnsearch(kdtreeobj,cpts,'k',(numNeighbours+1));
smoothness_list=zeros(size(cpts,1),1);
%% 
for i=1:size(cpts,1)
    tc=tangents(i,:);
    tn=tangents(neighbours(i,2:end),:);
    cos_sim_list=zeros(numNeighbours,1);
    for j=1:numNeighbours
        cos_sim_list(j)=abs(2*acos(dot(tc,tn(j,:))/(norm(tc)*norm(tn(j,:))))/pi-1);
    end
    smoothness_list(i)=min(cos_sim_list);
end
end


function d=EucDist(v1,v2)
    d=sqrt(sum((v1-v2).^2,2));
end