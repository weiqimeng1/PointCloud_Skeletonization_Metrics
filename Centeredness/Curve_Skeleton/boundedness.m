function boundness=boundedness(cpt,pts)
    vecs = cpt - pts;
    vnorms=vecnorm(vecs, 2, 2);
    % Vectorized normalization of vecs
    vecs_normimlised = vecs ./ vnorms;

    % Extract normalized coordinates
    x = vecs_normimlised(:,1);
    y = vecs_normimlised(:,2);
    z = vecs_normimlised(:,3);

    t_thetas = atan2(y, x);    

    temp1 = sqrt(x.^2 + y.^2);
    alphas = atan2(z, temp1);
    thetas = t_thetas .* temp1;


    sphere_pts = [thetas, alphas];

    % Triangulate the spherical points
    dt1 = delaunayTriangulation(sphere_pts);
    
    fb=freeBoundary(dt1);
    [~, vm_ind]=min(alphas(fb(:,1)));
    m=size(fb,1);
    cind1=vm_ind;
    cind2=mod(cind1, m) + 1;
    triangles2=zeros(m-2,3);
    left=mod(cind1-2, m) + 1; right=mod(cind2, m) + 1;
    for j=1:(m-2)
        if(alphas(fb(left,1))>alphas(fb(right,1)))
            cind3=right;
            triangles2(j,:)=[fb(cind1,1),fb(cind2,1),fb(cind3,1)];
            right=mod(right, m) + 1;
        else
            cind3=left;
            triangles2(j,:)=[fb(cind1,1),fb(cind2,1),fb(cind3,1)];
            left=mod(left-2, m) + 1;
        end
        
        cind1=cind2;cind2=cind3;
    end

    triangles1 = dt1.ConnectivityList;

    triangles=[triangles1;triangles2];

    % Vectorized area calculation for triangles
    vertex1 = vecs_normimlised(triangles(:, 1), :);
    vertex2 = vecs_normimlised(triangles(:, 2), :);
    vertex3 = vecs_normimlised(triangles(:, 3), :);

    % Calculate edge vectors and cross products
    vectorA = vertex2 - vertex1;
    vectorB = vertex3 - vertex1;
    crossProds = cross(vectorA, vectorB, 2);

    % Compute areas and apply the condition to zero out areas > 0.1
    areas = vecnorm(crossProds, 2, 2) / 2;

    dis2tri=0.5*dot(vertex1,crossProds,2)./areas;

    avenorm=mean(vnorms(triangles),2);

    areas(dis2tri<0.8 &  avenorm.^2.*areas<1e-4)=0;

    boundness = sum(areas) / (4 * pi);
end