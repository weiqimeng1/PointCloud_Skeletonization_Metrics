function [refined_vertices,refined_adj]=refine_curve(input_vertices, input_adj, diameter)
refined_vertices=input_vertices;
refined_adj=input_adj;
%% remove NaN vertices
ind=ones(size(refined_vertices,1),1);
for i=1:size(refined_vertices,1)
    if isnan(refined_vertices(i,1))
        ind(i)=0;
    end
end
ind=ind&1;
refined_vertices=refined_vertices(ind,:);
refined_adj=refined_adj(ind, ind);

%% remove abnormal edges (merge similar edges resulting very flat featureless loops)
for i=1:size(refined_adj,1)
    refined_adj(i,i)=0;
    % neighbor count
    nc=sum(refined_adj(i,:)>0);
    if(nc>2)
        pn_ind=find(refined_adj(i,:)>0);
        pn=refined_vertices(pn_ind,:);
        pc=refined_vertices(i,:);
        vn_Nonnomilised=pn-repmat(pc,size(pn,1),1);
        vn=vn_Nonnomilised./repmat(sqrt(sum(vn_Nonnomilised.*vn_Nonnomilised,2)),1,3);
        vNum=size(pn,1);
        checking_list=zeros(vNum,1);
        for j=1:vNum
            for k=(j+1):vNum
                if ~checking_list(k)&&dot(vn(j,:),vn(k,:))>0.98
                    refined_vertices(pn_ind(j),:)=pc+dot(vn_Nonnomilised(j,:),vn(k,:))*vn(k);
                    refined_adj(i,pn_ind(k))=0; refined_adj(pn_ind(j),pn_ind(k))=1;
                    refined_adj(pn_ind(k),i)=0; refined_adj(pn_ind(k),pn_ind(j))=1;
                    checking_list(k)=1;
                    break;
                end
            end
        end
    end
end
%% Merge close vertices
dist_thereshold=diameter*0.02;
rcv_flag=false;
count=0;
while(~rcv_flag)
    count=count+1;
    rcv_flag=true;
    remained_musk=true(size(refined_adj,1),1);
    for i=1:size(refined_adj,1)
        if remained_musk(i)
            % neighbor count
            neighbor_ind=find(refined_adj(i,:)>0);
            if length(neighbor_ind)<2
                continue;
            end
            neibor_points=refined_vertices(neighbor_ind,:);
            object_point=refined_vertices(i,:);
            dist_list=sqrt(sum((neibor_points-repmat(object_point,size(neibor_points,1),1)).^2,2));
            [dmin,ind]=min(dist_list);
            mind=neighbor_ind(ind);
            if dmin<dist_thereshold && remained_musk(mind)
                rcv_flag=false;
                remained_musk(mind)=false;
                ind_connected_min=logical(refined_adj(mind,:));
                ind_connected_min(i)=false;
                refined_adj(i,ind_connected_min)=1;
                refined_adj(:,i)=refined_adj(i,:)';
                refined_vertices(i,:)=0.5*(refined_vertices(i,:)+refined_vertices(mind,:));
            end
        end
    end
    refined_vertices=refined_vertices(remained_musk,:);
    refined_adj=refined_adj(remained_musk,remained_musk);
end
end