% Total path is formulated based on the cost matrix. 

function [path2follow] = TotalPath(resultRoute, Orch, XY, actualstart, actualend)
global C;
N = Orch.K;
w = Orch.w;

path2follow = [];
for i = 1:length(resultRoute)-1
    if mod(N,2) ~=0 && i == length(resultRoute)-1
        break;
    elseif mod(N,2) == 0 && i == length(resultRoute)-1
        break;
    end
    
    if mod((resultRoute(i+1) - resultRoute(i)),N) == 0 || i == 1 ||(i == length(resultRoute) -1)
        iterPath = pathStraight(resultRoute(i),resultRoute(i+1),XY,C.stepsize);       
        
    else
        
        
        d = abs(resultRoute(i+1) - resultRoute(i));
        dist = d*w;
        
        if dist >= 2*C.Rmin
            iterPath = pathPi(resultRoute(i),resultRoute(i+1),XY,C.Rmin,N,C.stepsize);
        else
            iterPath = pathOmega(resultRoute(i),resultRoute(i+1),XY,C.Rmin,N,dist,C.stepsize);
        end
    end
    path2follow = [path2follow iterPath];
end

if mod(N,2)~=0
    if resultRoute(i) == N+ceil(N/2)+1
        startPt = N+ceil(N/2)+1;
        endPt = N+ceil(N/2)+2;
    else
        startPt = resultRoute(i);
        endPt = N+ceil(N/2)+1;
    end
    dist = w;
    if dist >= 2*C.Rmin
        iterPath = pathPi(startPt,endPt,XY,C.Rmin,N,C.stepsize);
    else
        iterPath = pathOmega(startPt,endPt,XY,C.Rmin,N,dist,C.stepsize);
    end
    iterPath2 = pathStraight(endPt,endPt-N,XY,C.stepsize);
    path2follow = [path2follow iterPath iterPath2];
    
end
% Orch.Vpoint2 = [floor(N/2)*w+Orch.SWcorner(1);Orch.SWcorner(2)-4*C.Rmin];

% npoints = 5000; % number of evenly spaced intervals between starting/ending point and virtual node    
% % initialroute1 = [linspace(actualstart(1),Vpoint2(1),npoints);...
% %    linspace(actualstart(2),Vpoint2(2),npoints)];
% 
% initialroute2 = [linspace(Orch.Vpoint2(1),path2follow(1,1),npoints);...
%    linspace(Orch.Vpoint2(2),path2follow(2,1),npoints)];
% 
% 
% % finalroute = [linspace(path2follow(1,end),actualend(1,1),npoints);...
% %     linspace(path2follow(2,end),actualend(2,1),npoints)];
% % path2follow = [initialroute2 path2follow finalroute];
% 



figure
plot(path2follow(1,:),path2follow(2,:));
% axis square

end