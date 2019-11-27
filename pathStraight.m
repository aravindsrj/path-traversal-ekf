function straight_path = pathStraight(index1,index2,XY,dstep)
% if index1 < index2
%     dist = XY(index1,2):dstep:XY(index2,2);
% else
%     dist = XY(index2,2):dstep:XY(index1,2);
%     dist = flip(dist);
% end
% 
% straight_path = [XY(index1,1)*ones(1,length(dist));dist];
n = 3000;
x = linspace(XY(index1,1),XY(index2,1),n);
y = linspace(XY(index1,2),XY(index2,2),n);
straight_path = [x;y];

end