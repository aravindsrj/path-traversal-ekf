% This is where coordinates are allocated to each node

function XY = NodeOperations(Orch)
N = Orch.K;
SWcorner = Orch.SWcorner;
w = Orch.w;
RL = Orch.RL;

XY = zeros(3*N+2,2);
% Creation of Virtual node. This acts as starting and ending point in the
% GA
XY(1,1) = Orch.VirtualStart(1);
XY(1,2) = Orch.VirtualStart(2);
XY(3*N+2,:) = XY(1,:);

% Setting coordinates to nodes
for i = 2:N+1
    
    XY(i,1) = XY(i-1,1) + w;
    if i == 2
        XY(i,1) = SWcorner(1);
    end
    XY(i,2) = SWcorner(2);    
    XY(N+i,1) = XY(i,1);
    XY(N+i,2) = RL + XY(i,2);
    XY(2*N+i,1) = XY(i,1);
    XY(2*N+i,2) = RL/2 + XY(i,2);
end

end