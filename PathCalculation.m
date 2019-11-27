% If the file properties.mat is saved and unchanged in the path, this
% function exits. Otherwise, Node Operations are calculated to determine
% the optimal path

function [initialpath,resultRoute] = PathCalculation(Orch)
global C;
flag = 0;

try
    load('properties.mat','orchardProps','robotProps','initialpath', 'resultRoute');
    if ~isequal(orchardProps,Orch) || ~isequal(robotProps,C)
        flag = 1;
    end
catch
    flag = 1;
end

if flag == 1
        %%%%%%%%%%%%%%%%%%% Node Operations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    XY = NodeOperations(Orch);


    %% Cost matrix
    resultRoute = CostOperations(XY, Orch.K, Orch.w);

    %% Path formulation
    [initialpath] = TotalPath(resultRoute, Orch, XY, C.actualstart, C.actualend);
    
    robotProps = C;
    orchardProps = Orch;
    save('properties.mat', 'robotProps', 'orchardProps','initialpath','resultRoute');
    
end
    