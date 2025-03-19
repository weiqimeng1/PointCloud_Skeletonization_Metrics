function [curvature_list, Vert_label,vertice_weights]=curve_vertex_curvature(vertices,vertex_adj)
%% Construct Graph
A=vertex_adj;
G = graph(A,'upper','OmitSelfLoops');
% v = dfsearch(G,1);

%% calculate Edge Length
vertice_weights=zeros(size(vertices,1),1);
X=G.Edges.EndNodes;
edge_Length_list=zeros(size(vertices,1),1);   % Edge length
Vert_label=zeros(size(vertices,1),1);  % Vertex label
for i=1:size(X,1)
    v1=vertices(X(i,1),:); v2=vertices(X(i,2),:);
    edge_Length_list(i)=EucDist(v1,v2);
    Vert_label(X(i,1))=Vert_label(X(i,1))+1; Vert_label(X(i,2))=Vert_label(X(i,2))+1; 
    vertice_weights(X(i,1))=vertice_weights(X(i,1))+edge_Length_list(i);
    vertice_weights(X(i,2))=vertice_weights(X(i,2))+edge_Length_list(i);
end
vertice_weights=vertice_weights./Vert_label;
vertice_weights(Vert_label==2)=vertice_weights(Vert_label==2)./sum(vertice_weights(Vert_label==2),"all");
vertice_weights(Vert_label~=2)=NaN;
curvature_list=zeros(size(vertices));
%% sampling points evenly on the curve
for i=1:length(Vert_label)
    if Vert_label(i)==2
        nlist=find(vertex_adj(i,:));
        B=vertices(nlist(1),:);
        A=vertices(i,:);
        C=vertices(nlist(2),:);
        if dot(B-A,C-A)/(norm(B-A)*norm(C-A))>-0.99 && dot(B-A,C-A)/(norm(B-A)*norm(C-A))<0.99
            [~,~,k] = circumcenter_AM(A,B,C);
            curvature_list(i,:)=k;
        else
            curvature_list(i,:)=[0,0,0];
        end
    else
        vertice_weights(i)=NaN;
        curvature_list(i,:)=NaN;
    end
end

end

function d=EucDist(v1,v2)
    d=sqrt(sum((v1-v2).^2,2));
end