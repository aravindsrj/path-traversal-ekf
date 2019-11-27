function omega_path = pathOmega(index1,index2,XY,Rmin,N,dist,dstep)
gamma = acos(1 - ((2*Rmin + dist)^2)/(8*Rmin^2));
alpha = (pi-gamma)/2;

if index1 > N+1 && index2 < 2*N+2 % If upper headland

    if index1 < index2
          C1 = arc(-1, 0, alpha, 0, 0, index1, XY, Rmin, dstep,dist,alpha);
          C2 = arc(1, -alpha, pi+alpha, 1, 1, index1, XY, Rmin, dstep, dist,alpha);
          C3 = arc(1, pi-alpha, pi, 0, 0, index2, XY, Rmin, dstep, dist,alpha);
          omega_path = [C1 C2 C3];        
    else
        C1 = arc(1, pi-alpha, pi, 1, 0, index1, XY, Rmin, dstep,dist,alpha);
        C2 = arc(1, -alpha, pi+alpha, 0, 1, index2, XY, Rmin, dstep, dist,alpha);
        C3 = arc(-1, 0, alpha, 1, 0, index2, XY, Rmin, dstep, dist,alpha);
        omega_path = [C1 C2 C3];        
    end
elseif index2 < 2*N+2 % If lower headland    
    
    if index1<index2
        C1 = arc(-1, -alpha, 0, 1, 0, index1, XY, Rmin, dstep,dist,alpha);
        C2 = arc(-1, pi-alpha, 2*pi+alpha, 0, 1, index1, XY, Rmin, dstep, dist,alpha);
        C3 = arc(+1, pi, pi+alpha, 1, 0, index2, XY, Rmin, dstep, dist,alpha);
        omega_path = [C1 C2 C3];        
    else
        C1 = arc(1, pi, pi+alpha, 0, 0, index1, XY, Rmin, dstep,dist,alpha);
        C2 = arc(-1, pi-alpha, 2*pi+alpha, 1, 1, index2, XY, Rmin, dstep, dist,alpha);
        C3 = arc(-1, -alpha, 0, 0, 0, index2, XY, Rmin, dstep, dist,alpha);
        omega_path = [C1 C2 C3];                
    end
    
else % if the turn is to the ending point
        C1 = arc(1, pi, pi+alpha, 0, 0, index1, XY, Rmin, dstep,dist,alpha);
        C2 = arc(-1, pi-alpha, 2*pi+alpha, 1, 1, index2, XY, Rmin, dstep, dist,alpha);
        C3 = arc(-1, -alpha, 0, 0, 0, index2, XY, Rmin, dstep, dist,alpha);
        omega_path = [C1 C2 C3];
        
end

end