function pts_ind=retrive_pts_by_cutting_plane(pts_list,plane_param,interval)
% By Qingmeng Wen 30/8/2024
% input: pts_list:points coordinates
%        plane_param:[p1,p2,p3,p4]specify a plane that passing the anchor point as p1*x+p2*y+p3*z+p4=0
%        interval between the two cutting plane arround the anchor point
% output:The logical index of the selected points relative to the pts_list
normal=plane_param(1:3);
if size(normal,1)>1
    normal=normal';
end
D=plane_param(4);
dist_list=abs(pts_list*normal'+D)/norm(normal); % just in case normal is not normilised
pts_ind=dist_list<0.5*interval;
end