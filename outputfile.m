load('images.mat');
load('properties.mat');
Orch = orchardProps;
[centers,radii] = imfindcircles(BW,[5 15], 'Sensitivity',0.91);
imshow(BW);
h = viscircles(centers,radii);
X = [Orch.SWcorner(1)-Orch.w Orch.SWcorner(1)-Orch.w+Orch.K*Orch.w];
Y = [Orch.SWcorner(2)-Orch.w/2 Orch.SWcorner(2)+Orch.RL+Orch.w/2];
imgsize = size(BW);
imgRes = imgsize(2)/(Y(2)-Y(1));
actualRadii = radii./imgRes;

Xmax = X(2)-X(1);
Ymax = Y(2) - Y(1);
Row = 420;
Col = 560;
actualCenters = zeros(length(centers),2);

% for i = 1:length(centers)
%     actualCenters(i,:) = IJtoXY(centers(i,1),centers(i,2),Xmax,Ymax,Row,Col);
% end

actualCenters2 = IJtoXY2(centers(:,1),centers(:,2),Xmax,Ymax,Row,Col);