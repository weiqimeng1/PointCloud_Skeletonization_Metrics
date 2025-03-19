function centeredness_list=edge_point_centeredness(pts, curve_pts, curv_dirs, diameter)

%% get cutting plane
plane_param_list=zeros(size(curve_pts,1),4);
v1_list=zeros(size(curve_pts,1),3);
v2_list=zeros(size(curve_pts,1),3);

for i=1:size(curve_pts,1)
    plane_normal_vec=curv_dirs(i,:);
    if plane_normal_vec(3)==0
        v1=[plane_normal_vec(2),-plane_normal_vec(1),0];
        v1=v1./norm(v1);
        v2=cross(v1,plane_normal_vec(:));
        v2=v2./norm(v2);
    else
        v1=[plane_normal_vec(3),0,-plane_normal_vec(1)];
        v1=v1./norm(v1);
        v2=cross(v1,plane_normal_vec(:));
        v2=v2./norm(v2);
    end
    D=-dot(plane_normal_vec,curve_pts(i,:));
    plane_param_list(i,:)=[plane_normal_vec,D];
    v1_list(i,:)=v1;
    v2_list(i,:)=v2;
end

%% 
centeredness_list=zeros(size(curve_pts,1),1);
for anchor_ind=1:size(curve_pts,1)
    if isnan(curv_dirs(anchor_ind,1))
        centeredness_list(anchor_ind)=NaN;
        continue;
    end
    pts_ind=retrive_pts_by_cutting_plane(pts,plane_param_list(anchor_ind,:),diameter*0.02);
    selected_pts=pts(pts_ind,:);
    if size(selected_pts,1)<=2
        centeredness_list(anchor_ind)=NaN;
        continue;
    end
    
    % project to plane
    x_span=v1_list(anchor_ind,:);
    y_span=v2_list(anchor_ind,:);
    skeleton_pt=curve_pts(anchor_ind,:);
    proj_pts=[selected_pts*x_span',selected_pts*y_span'];
    proj_skeleton_vert=[skeleton_pt*x_span',skeleton_pt*y_span'];
    
    % Find the interested points
    pts_num=size(proj_pts,1);
    distance2skel_pt=sqrt(sum((repmat(proj_skeleton_vert,pts_num,1)-proj_pts).^2,2));
    [dlist,dind]=sort(distance2skel_pt);
    interested_ind=false(pts_num,1);
    maxd=dlist(1);
    interested_ind(dind(1))=true;
    for i=2:pts_num
        if dlist(i)<maxd*1.5
            maxd=dlist(i);
            interested_ind(dind(i))=true;
        else
            break;
        end
    end
    if sum(interested_ind)<=2
        centeredness_list(anchor_ind)=NaN;
        % if true
        %     figure(4);
        %     pcshow(pts)
        %     hold on
        %     pcshow(selected_pts,'w')
        %     plot3(skeleton_pt(1), skeleton_pt(2), skeleton_pt(3), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r'); % 绘制点，红色圆圈
        %     hold off
        % end
        continue;
    end
    
    % average centre
    interested_prj_pts=proj_pts(interested_ind,:);
    [ellipse_param,fitted_flag]=EllipseDirectFit(interested_prj_pts);
    if fitted_flag
        F=ellipse_param(6);
        A=ellipse_param(1)/F;B=ellipse_param(2)/F;C=ellipse_param(3)/F;
        D=ellipse_param(4)/F;E=ellipse_param(5)/F;
        Xc=(B*E-2*C*D)/(4*A*C-B^2); Yc=(B*D-2*A*E)/(4*A*C-B^2);
        fitted_center=[Xc,Yc];
        
        temp1=A*Xc^2+C*Yc^2+B*Xc*Yc-1;
        temp2=sqrt((A-C)^2+B^2);
        a=sqrt(2*temp1/(A+C+temp2));
        b=sqrt(2*temp1/(A+C-temp2));
        r=(a+b)/2;
    else
        fitted_center=mean(interested_prj_pts);
        r=maxd;
    end


    skel_vert2ave_center=sqrt(sum((proj_skeleton_vert-fitted_center).^2));
    if abs(imag(r))>1e-5
        disp(r)
        warning("Unexpected ellipse fitting");
    end
    % ave_dis2ave_center=mean(sqrt(sum((repmat(fitted_center,size(interested_prj_pts,1),1)-interested_prj_pts).^2,2)));
    centeredness_list(anchor_ind)=1-skel_vert2ave_center/r;
    if centeredness_list(anchor_ind)<0
        centeredness_list(anchor_ind)=0;
    end
    % disp(centeredness_list(anchor_ind))
    % interested_pts=selected_pts(interested_ind,:);
end

end