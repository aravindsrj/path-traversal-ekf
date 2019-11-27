% This function generates a circular arc, that is used for pi turn and
% omega turn

% Inputs:
%   -Plusminus - A multiplier of +/- 1
%   -start - Starting angle (in radians) of the arc
%   -final - Final angle (in radians) of the arc
%   -flipvalue - Value of 1 or 0, to decide if the sequence of indices of
%                the arc generated must be flipped
%   -middleturn - Value of 1 or 0, to know weather the arc drawn is the
%               central arc of the omega turn (this value is 0 for pi turn)
%   -index - the index in XY whose points are taken
%   -XY - the XY matrix
%   -Rmin - Minimum radius of curvature possible for the robot
%   -dstep - interval size between two consecutive points of the path
%   -dist - For pi turn, this value is 0. For omega turn, it is mostly
%           equal to d*w
%   -alpha - For pi turn, this value is 0. For omega turn, it is the angle
%            alpha (in radians)
% Output:
%   -C - the arc path
function A = arc(plusminus, start, final, flipvalue, middleturn, index,...
    XY, Rmin, dstep, dist,alpha)
    
if middleturn == 0
    center = [XY(index,1)+plusminus*Rmin XY(index,2)];
    cirpts = start:dstep:final;
    A = [center(1)+Rmin*cos(cirpts); center(2)+Rmin*sin(cirpts)]; 
else
    center = [XY(index,1)+dist/2 XY(index,2)+plusminus*2*Rmin*sin(alpha)];
    cirpts = start:dstep:final;
    A = [center(1)+Rmin*cos(cirpts); center(2)+Rmin*sin(cirpts)];
end
    
    if flipvalue == 1
        A = flip(A,2);
    end
end