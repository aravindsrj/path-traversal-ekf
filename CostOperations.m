% Costs are allocated to each path between nodes

function resultRoute = CostOperations(XY, N, w)
global C;
HUGE = 1e10;
dmat = zeros(3*N+2);

% Setting straight line costs between headlands
for i =2:N+1
    for j = N+2:2*N+1
        %if j-i == N
         %   dmat(i,j) = 0*RL;
          %  dmat(j,i) = dmat(i,j);
        %else
            dmat(i,j) = HUGE;
            dmat(j,i) = dmat(i,j);
        %end
    end
end

for i = 2:N+1
    for j = 2*N+2:3*N+1
        if j-i == 2*N
            dmat(i,j) = 0;
            dmat(j,i) = dmat(i,j);
            dmat(N+i,j) = 0;
            dmat(j,N+i) = 0;
        else
            dmat(i,j) = HUGE;
            dmat(j,i) = dmat(i,j);
            dmat(N+i,j) = HUGE;
            dmat(j,N+i) = HUGE;
        end
    end
end            
        

% Setting turning costs
for i = 2:N
    for j = i+1: N+1
        d = j-i;
        
        if d*w >= 2*C.Rmin
            dmat(i,j) = d*w + (pi-2)*C.Rmin;
            dmat(j,i) = dmat(i,j);
            dmat(i+N,j+N) = d*w + (pi-2)*C.Rmin; 
            dmat(j+N,i+N) = dmat(i+N,j+N);

        else
            dmat(i,j) = 3*pi*C.Rmin - 2*C.Rmin*acos(1 - ((2*C.Rmin + d*w)^2)/(8*C.Rmin^2));
            dmat(j,i) = dmat(i,j);
            dmat(i+N,j+N) = 3*pi*C.Rmin - 2*C.Rmin*acos(1 - ((2*C.Rmin + d*w)^2)/(8*C.Rmin^2));
            dmat(j+N,i+N) = dmat(i+N,j+N);
        end
        dmat(2*N+i,2*N+j) = HUGE;
        dmat(2*N+j,2*N+i) = HUGE;
    end
end

% cost involving start and end points
for i = 2:N+1
    dmat(1,i) = abs(XY(i,1) - XY(1,1)) + abs( XY(i,2) - XY(1,2)); % start point and lower points
    dmat(i,1) = dmat(1,i); % start point and lower points
    dmat(1,i+N) = HUGE; % start point and upper points
    dmat(i+N,1) = dmat(1,i+N); % start point and upper points
    dmat(3*N+2,i) = HUGE; % end point and lower points
    dmat(i,3*N+2) = abs(XY(i,1) - XY(3*N+2,1)) + abs( XY(i,2) - XY(3*N+2,2)); %end point and lower points

        
    dmat(3*N+2,i+N) = HUGE; % end point and upper points
    dmat(i+N,3*N+2) = dmat(3*N+2,i+N); % end point and upper points
    
    dmat(1,2*N+i) = HUGE; % start point and middle points
    dmat(2*N+i,1) = HUGE; % start point and middle points
    dmat(3*N+2,2*N+i) = HUGE; % end point and middle points
    dmat(2*N+i,3*N+2) = HUGE;% end point and middle points
   
end
dmat(1,3*N+2) = HUGE; % start and end points
dmat(3*N+2,1) = HUGE; % start and end points

% upper two points with end point
for i = N+ceil(N/2)+1:N+ceil(N/2)+2
    dmat(i,3*N+2) = abs(XY(i,1) - XY(3*N+2,1)) + abs( XY(i,2) - XY(3*N+2,2));
    dmat(3*N+2,i) = dmat(i,3*N+2);
end

result = tspof_ga('xy',XY,'dmat',dmat);
% Adding the start and end points (virtual) to the optimal route sequence
resultRoute = [1 result.optRoute 3*N+2];
