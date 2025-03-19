function [smoothness_list, Vert_label,weights]=curve_smoothness_by_cosine(vertices,vertex_adj)
%% Construct Graph
A=vertex_adj;
G = graph(A,'upper','OmitSelfLoops');
% v = dfsearch(G,1);

%% calculate Edge Length weights
weights=zeros(size(vertices,1),1);
X=G.Edges.EndNodes;
edge_Length_list=zeros(size(vertices,1),1);   % Edge length
Vert_label=zeros(size(vertices,1),1);  % Vertex label
for i=1:size(X,1)
    v1=vertices(X(i,1),:); v2=vertices(X(i,2),:);
    edge_Length_list(i)=EucDist(v1,v2);
    Vert_label(X(i,1))=Vert_label(X(i,1))+1; Vert_label(X(i,2))=Vert_label(X(i,2))+1; 
    weights(X(i,1))=weights(X(i,1))+edge_Length_list(i);
    weights(X(i,2))=weights(X(i,2))+edge_Length_list(i);
end
weights=weights./2;
smoothness_list=zeros(size(vertices,1),1);
%% smoothness of the curve
for i=1:length(Vert_label)
    if Vert_label(i)==2
        nlist=find(vertex_adj(i,:));
        B=vertices(nlist(1),:);
        A=vertices(i,:);
        C=vertices(nlist(2),:);
        smoothness_list(i)=abs(2*acos(dot(B-A,C-A)/(norm(B-A)*norm(C-A)))/pi-1);
    else
        smoothness_list(i)=NaN;
    end
end
end


function d=EucDist(v1,v2)
    d=sqrt(sum((v1-v2).^2,2));
end