function [centeredness_list]=skeletal_centeredness(P,Q,Neighbor_num)
% centeredness between original point set P [m1 x 3] and skeletal point set Q =[m2 x 3]
% @author: Q. Wen

[m2,~]=size(Q);
if Neighbor_num<10
    N=10;
elseif Neighbor_num>50
    N=30;
else
    N=Neighbor_num;
end


kdtree2 = KDTreeSearcher(Q);
ind2q = knnsearch(kdtree2,Q,'K',m2);

visited=false(m2,1);
centeredness_list=zeros(m2,1);
cind=1;

for i=1:m2
    selectedp=P(ind2q(cind,1:N),:);
    spc=mean(selectedp,1);
    selectedq=Q(ind2q(cind,1:N),:);
    sqc=mean(selectedq,1);
    
    v1=spc-sqc;
    M=mean(EucDist(sqc,selectedp));
    centeredness_list(cind)=1-norm(v1)/M;
    if centeredness_list(cind)<0
        centeredness_list(cind)=0;
    end
    visited(cind)=true;
    j=2;
    while(visited(ind2q(cind,j)) && i<m2)
        j=j+1;
    end
    cind=ind2q(cind,j);
end
end

function d=EucDist(v1,v2)
    d=sqrt(sum((v1-v2).^2,2));
end
