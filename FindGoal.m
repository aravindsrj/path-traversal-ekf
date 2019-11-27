function [goal, end_of_path, index] = FindGoal(index, path2follow, part, X, end_of_path, goal)
global C;
if index > length(path2follow) - part
    part = length(path2follow) - index;
end
% if index == 22
%     keyboard
% end
for i = index:index+part
    dist = sqrt((X(1) - path2follow(1,i))^2 + (X(2) - path2follow(2,i))^2);
    if dist > C.Ld - C.stepsize/2 % Finding the lookout point (first point greater than 1.9995)
        index = i;
        goal = [path2follow(1,i);path2follow(2,i)];
        break;
    end
    if i == length(path2follow) % Checking if end of path is within the lookout distance
        end_of_path = 1;
    end
end
end