% This function returns two variables, path2follow and theoretical_path.
% Both variables are the modified path that the robot can process.
% 'theoretical_path' has no significance in the functioning of the robot...
... It is only used for calculating the error distance of the robot.
% 'path2follow' is a sorted path, of which, the initial index is the first
% point that is 'Ld' distance away. This is the path that the robot checks
% at every iteration to determine the goal point.

% In the case where two or more points exist at 'Ld' distance away, the
% robot chooses to move to the point that is closer to the tip of the robot

function [path2follow,theoretical_path] = findpath(initialpath, q, Ld, T, stepsize)
    global tractor
    npoints = 0;
    foundat = 0;
    initial_index = 1;
    n = length(initialpath);
    n2 = n/2; % first half of the path
    min = 1e6; % an arbitrary large number
    p = 1; 
    for i = 1:n2 % checks for minimum distance in the first half of the path
        d = sqrt((q(1) - initialpath(1,i))^2 + (q(2) - initialpath(2,i))^2);
        if (d < Ld + p*stepsize) && (d > Ld - p*stepsize)
            npoints = npoints + 1; % checking how many points exist at 'Ld' distance away
            foundat(npoints) = i; % storing the index of all points 'Ld' distance away
        end
        if d < min
            min = d; % the point of the path that is closest to the robot
            min_index = i;
        end
    end
    
    Tip = T * [tractor(1,2);tractor(2,2);1]; % Coordinates of the tip of the robot in world coordinates
    min = 1e6;
    % Finding the distance from the tip of the robot
    for i = 1:npoints
        D = sqrt((Tip(1) - initialpath(1,foundat(i)))^2 + (Tip(2) - initialpath(2,foundat(i)))^2);
        if D < min
            min = D;
            initial_index = foundat(i);
        end
    end

    theoretical_path = [initialpath(1,min_index:n);...
        initialpath(2,min_index:n)];
    path2follow = [initialpath(1,initial_index:n);...
            initialpath(2,initial_index:n)];
     
end