function pi_path = pathPi(index1,index2,XY,Rmin,N,dstep)

if index1 > N+1 && index2 <= 2*N+1 % if upper headland

    if index1 < index2
        dist_straight = XY(index1,1)+Rmin:dstep:XY(index2,1)-Rmin;
        L1 = [dist_straight; (XY(index1,2)+Rmin)*ones(1,length(dist_straight))];        
        C1 = arc(1, pi/2, pi, 1, 0, index1, XY, Rmin, dstep,0,0);        
        C2 = arc(-1, 0, pi/2, 1, 0, index2, XY, Rmin, dstep, 0,0);
        pi_path = [C1 L1 C2];
        
    else
        dist_straight = XY(index2,1)+Rmin:dstep:XY(index1,1)-Rmin;
        L1 = [dist_straight; (XY(index1,2)+Rmin)*ones(1,length(dist_straight))];
        L1 = flip(L1,2);        
        C1 = arc(-1, 0, pi/2, 0, 0, index1, XY, Rmin, dstep,0,0);        
        C2 = arc(1, pi/2,pi, 0, 0, index2, XY, Rmin, dstep, 0,0);
        pi_path = [C1 L1 C2];
    end
    
elseif index2 < 2*N+2 % if lower headland

    if index1<index2
        dist_straight = XY(index1,1)+Rmin:dstep:XY(index2,1)-Rmin;
        L1 = [dist_straight; (XY(index1,2)-Rmin)*ones(1,length(dist_straight))];
        C1 = arc(1, pi, 3*pi/2, 0, 0, index1, XY, Rmin, dstep,0,0);        
        C2 = arc(-1, 3*pi/2,2*pi, 0, 0, index2, XY, Rmin, dstep, 0,0);
        pi_path = [C1 L1 C2];
    else
        dist_straight = XY(index2,1)+Rmin:dstep:XY(index1,1)-Rmin;
        L1 = [dist_straight; (XY(index1,2)-Rmin)*ones(1,length(dist_straight))];
        L1 = flip(L1,2);
        C1 = arc(-1, 3*pi/2, 2*pi, 1, 0, index1, XY, Rmin, dstep,0,0);        
        C2 = arc(1, pi,3*pi/2, 1, 0, index2, XY, Rmin, dstep, 0,0);
        pi_path = [C1 L1 C2];
    end
    
else % if the turn is to the ending point
        dist_straight = XY(index2,1)+Rmin:dstep:XY(index1,1)-Rmin;
        L1 = [dist_straight; (XY(index1,2)-Rmin)*ones(1,length(dist_straight))];
        L1 = flip(L1,2);
        C1 = arc(-1, 3*pi/2, 2*pi, 1, 0, index1, XY, Rmin, dstep,0,0);        
        C2 = arc(1, pi,3*pi/2, 1, 0, index2, XY, Rmin, dstep, 0,0);
        pi_path = [C1 L1 C2];    
end
        
end