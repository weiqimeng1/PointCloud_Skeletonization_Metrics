function flag=IsRingOkay(rings, npts)
    for i=1:npts
        ring=rings{i};
        ringlen=length(ring);
        for j=1:ringlen
            if ring(j)==i
                disp(i)
                disp(ring)
                flag=false;
                return;
            end
        end
    end
    flag=true;
end