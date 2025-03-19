function NewPt=ProcessLayer(Pt)
oldp=Pt;
sizes = GS.one_ring_size(oldp.cpts, oldp.rings, 1);
RADIUS=sizes;
while min(RADIUS)<0.02*oldp.diameter
    newp=oldp;
    kdtree = kdtree_build( oldp.cpts );
    for i=1:newp.npts
        if RADIUS(i)>=0.02*oldp.diameter
            continue
        else
            [nIdxs, ~] = kdtree_ball_query( kdtree,oldp.cpts(i,:), RADIUS(i));
            if length(nIdxs)>=2
                newp.cpts(i,:)=mean(oldp.cpts(nIdxs,:));
            end
            RADIUS(i)=2*RADIUS(i);
        end
    end
    oldp=newp;
end
NewPt=oldp;
end
