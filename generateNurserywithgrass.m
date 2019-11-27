% This function randomly generates trees in rows. The presence of trees
% would change the occupancy value of the bitmap to True. The rows are
% aligned North-South.
%
% The trunk diameter and the number of trees are varied randomly.
%
% Apart from trees, specks of grass are introduced within the nursery (or
% arena). They have a smaller occupancy diameter.


function [Xmax,Ymax,Row,Col] = generateNurserywithgrass
rng('shuffle'); %init random generator
global bitmap;

Row = 5000; Col = 5000; %numbers of rows and columns of bitmap
bitmap = zeros(Row, Col); %initialize as empty

K = 5; % number of tree rows running south-north direction
M = 7; %maximum number of trees in each row
W = 3; % distance between tree rows (m)
D = 2; %distance between trees in the same row (m)
Gmin = 0.1; %distance between tall grass in the same row(m) 
Gmax = 3;

Xmax = 50; Ymax = Xmax; % Max coordinate value in each axis

%Uncomment the following line to have different Xmax to Ymax
% Xmax = W*(K-1)+30; Ymax = Xmax;

gridResolution = Xmax/Row;
x_im=[0 Xmax]; y_im=[0 Ymax]; % to display image with proper axes

x = zeros(M, K); y= zeros(M, K); %allocate arrays that hold tree center coordinates
a = zeros(M, K); b= zeros(M, K);% allocate arrays that hold grass center coordniates
maxTreeRadius = 0.5; %(m)
minTreeRadius = 0.2; %(m)
mingrassrad = 0.01; %(m) 
maxgrassrad = 0.07; % (m)

a(1,1) = 20-W/2+0.2; b(1,1) =20.5; %coordinates of bottom left tall grass center (m) 
x(1,1) = 20-W/2; y(1,1) = 20; %coordinates of bottom-left tree center (m)
j=1; % current tree row
while (j<=K)
    for i = 2:M %create coordinates of centers of all trees in the row
        y(i,j) = y(i-1,j) + D; % trees coordinates
        x(i,j) = x(i-1,j);
        b(i,j) = b(i-1,j)+ Gmin +rand*(Gmax-Gmin); % grass coordinates
        a(i,j) = a(i-1,j);
    end
    % next row
    j = j+1;
    x(1,j) = x(1,j-1) + W; y(1,j) = 20; 
    a(1,j) = a(1,j-1)+ W; b(1,j) = 20; 
end
% assign a random radius to each tree
for j=1:K
    for i=1:M
        radius = (minTreeRadius + rand*(maxTreeRadius-minTreeRadius))/ (Xmax/Col); %(m)
        rad = (mingrassrad + rand*(maxgrassrad-mingrassrad))/(Xmax/Col);
        [I, J] = XYtoIJ(x(i,j), y(i,j), Xmax, Ymax, Row, Col);
        [Ig, Jg] = XYtoIJ(a(i,j),b(i,j),Xmax, Ymax, Row,Col);
        if rand > 0.002 
            draw_disc(I, J, radius, Row, Col); %plot tree trunk
            draw_disc(Ig, Jg, rad, Row, Col);%plot tall grass 
        end
    end
end

% figure(1); 
% imagesc(x_im, y_im, bitmap); %imagesc flips the bitmap rows, so correct this
% %imagesc(bitmap);
% %imagesc(x_im, y_im, flipud(bitmap)); %imagesc flips the bitmap rows, so correct this
% %set(gca,'YDir','normal');
% axis equal

end