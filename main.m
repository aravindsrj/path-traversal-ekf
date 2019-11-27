clear

close all
global dT; %integration interval
global DT; %control interval
global C; % constants and parameters
global tractor; % aka the robot
global rangeMax; % maximum range of the robot
global occ_odds; % Occupancy odds (odds format)
global occ_grid; % Occupancy probability
global bitmap; % the map of the arena 

addpath('geom2d/');
%% Generate Nursery
[Xmax,Ymax,ROW,COL] = generateNurserywithgrass; %physical dimensions of space (m)

D = 2; % Approximate distance between trees in a row
%% Robot Initialization and Genetic Algorithm

Time = 1000;
Animation = 0;
%%%%%%%%%%%% Robot Properties %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C.L = 3; % Length of Robot
C.Width = 2; % Width of Robot
C.Rw = 0.5; % (m); radius of wheel
C.tau_g = 0.1; % steering time lag (s)
C.tau_v = 0.2; % velocity time lag (s)
C.gammaMax = deg2rad(55); % (rad) Max steering angle
C.Vmax = 2; % (m/s); Max velocity of robot
C.Ld = 1.5; % (m); Lookout distance
C.delta1 = -0 * pi/180; C.delta2 = 0 * pi/180; C.slip = 0; % slip and skid constants
C.stepsize = 0.01;
C.Rmin = C.L/tan(C.gammaMax); % Minimum Radius of Turn
C.epsilon_dist = 0.75; 
C.epsilon_speed = 0.02; % (m/s)

% actual starting and ending points
C.actualstart = [0; 0];
C.actualend = [0; 0];
C.initialpose = pi/2;

%%%%%%%%%%%%%%%%%%%%%% Orchard Properties %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Orch.K = 6; % = number of rows + 1 = total number of north-south traversals by robot
Orch.RL = 20; % row length
Orch.w = 3; % width between rows
Orch.SWcorner = [17;20]; % start of field

% These virtual points determine the starting point of the field traversal
% algorithm
Orch.VirtualStart = [floor(Orch.K-1)*Orch.w+Orch.SWcorner(1);Orch.SWcorner(2)-2*C.Rmin];
Orch.Vpoint2 = [floor(Orch.K-1)*Orch.w+Orch.SWcorner(1);Orch.SWcorner(2)-4*C.Rmin];
Orch.Sweep = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[initialpath,resultRoute] = PathCalculation(Orch);


%%
initialPt = 0; % a switch to operate laser scanner of the robot
dT = 0.001; % (s) model integration stepsize
DT =  0.01; % (s) controller integration stepsize
N = Time/DT; % simulation stepsizes
%h = zeros(1,N);



% Setting initial Values for states and inputs
%%% State Vectors:
% q(1) ==> x-coordinate of robot
% q(2) ==> y-coordinate of robot
% q(3) ==> pose of robot (radians)
% q(4) ==> steering angle
% q(5) ==> linear velocity of robot

q = zeros(5, N); % state vectors over N time stepsizes
u=zeros(2, N); % input vectors over N time stepsizes

q(1,1) = C.actualstart(1); % initial x coordinate
q(2,1) = C.actualstart(2); % initial y coordinate
q(3,1) = C.initialpose; % initial pose of robot

% state constraints
% constraints respective to the states
Qmax(1) = Inf; Qmax(2) = Inf; Qmax(3) = Inf; 
Qmax(4) = C.gammaMax; Qmax(5) = C.Vmax;
Qmin = -Qmax; % symmetrical negative constraints for minimum values

% input constraints
umax(1) = C.gammaMax; umax(2) = C.Vmax;
umin = -umax;

% builds the tractor aka the robot
buildTractor2(C.L, C.Width);
% center of the robot
center_wrt_robot = [C.L/2;0];

% initializing parameters
index = 1;
k = 1;
end_of_path = 0; reached = 0;
part = C.Ld*500; % number of indices of the path that the robot checks to find goal point

%%%%%%%%%%%%%%%%%%%% Animation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Animation == 1
    figure
    xlim([-5 55]);
    ylim([-5 55]);
    hold on
    grid on
    %buildTractor2(C.L, C.Width);
    transform = transl2(q(1,1),q(2,1)) * trot2(q(3,1));
    robotObject = hgtransform;
    transObject(robotObject,transform);
    
    patch('XData', tractor(1,:), 'YData', tractor(2,:), 'FaceColor', 'r',...
        'Parent', robotObject);    
end

%%%%%%%%%%%%%%%%%% EKF initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

odo = zeros(2,N);
X = zeros(3,N); % estimated states
X(1,1) = q(1,1);
X(2,1) = q(2,1);
X(3,1) = q(3,1);
y = zeros(3,N); % sensor measurements


% Standard Deviation of Process Noise %
Q1 = 0.0495; bias1 = 0.001;
Q2 = 0.0105;

% Standard Deviation of Sensor Noise %
R1 = 0.03; R2 = 0.03; R3 = 0.02;

extKF.DT = 0.01; % EKF controller time rate
extKF.Q = diag([Q1, Q2].^2); % Process Noise covariance matrix
extKF.R = diag([R1, R2, R3].^2); % Sensor Noise covariance matrix
extKF.P = zeros(3); % Covariance Matrix

%% Laser Values %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rangeMax = 20; angleSpan = pi; angleStep = deg2rad(1.25); 

%Xmax = 50; Ymax = 50; 

Row = 500; Col = 500; %rows and columns; discretization of physical space in a grid

% bitmap = 0.0* ones(Row, Col); %initialize as empty
occ_odds = ones(Row, Col);
occ_grid = 0.5 * ones(Row, Col);


% flag changes to 1 when the robot reaches the first node of genetic
% algorithm. This is when the laser is switched on
flag = 0; 

%%
for t = 0:DT:Time-DT
        
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%     Input Calculation      %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if initialPt == 1
        if k == 1
            goal = path2follow(:,1);
        else
            % finding goal point (using look-ahead):
            [goal, end_of_path, index] = FindGoal(index, path2follow, part, X(:,k), end_of_path, goal);
        end
    else
        goal = Orch.Vpoint2;
        ex = goal(1) - X(1,k);  ey = goal(2) - X(2,k);
        th_d = atan2(ey, ex); % desired  direction of motion to reach xd,yd
        if (abs(ex) + abs(ey) > C.epsilon_dist)  %move if robot position is not close enough to the goal position
            u(2,k) = C.Vmax; %(m/s)
            u(1,k) = -angdiff(X(3,k),th_d);
        else
            initialPt = 1;
            T = transl2(X(1,k),X(2,k)) * trot2(X(3,k));
            [path2follow,theoretical_path] = findpath(initialpath, X(:,k), C.Ld, T, C.stepsize);  
            figure(1)
            plot(theoretical_path(1,:),theoretical_path(2,:),'LineWidth',2)
            flag = 1; % switch on laser
            hold on
        end            
    end
    
    if initialPt == 1
        % if look-ahead reached end of path, but robot did not:
        if end_of_path == 1 && reached ~= 1
            ex = goal(1) - X(1,k);  ey = goal(2) - X(2,k); % instantaneous errors in x and y axes
            if (abs(ex) + abs(ey) < C.epsilon_dist) % if robot reached end of path                
                u(1,k) = 0;
                u(2,k) = 0;
                reached = 1;                
            end
        end
    end
    
    if initialPt == 1
        if reached ~= 1
            u(:,k) = calcInput(X(:,k),u(:,k), goal);  % Calculating steering angle to reach the goal (noisy reading)
        else
            if q(5,k) < C.epsilon_speed % If robot has stopped moving after reaching the destination     (noisy)
                break;
            end
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%% Bicycle model integration %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [q(:,k+1), odo(:,k)] = robot_odo(q(:,k),u(:,k), umin, umax,...
                                Qmin, Qmax, C.L, C.tau_g, C.tau_v);
                            

%%%%%%%%%%%%%%%%%%%%%%% Sensor Measurements %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [y(1,k+1), y(2,k+1), y(3,k+1)] = GPS_CompassNoisy(q(1,k+1), q(2,k+1), q(3,k+1));
        

%%%%%%%%%%%%%%%%%%%%%%%% EKF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

    [X(:,k+1), extKF] = ExtKalman(extKF, odo(:,k), X(:,k), y(:,k+1),...
                                            u(:,k), t);
                                                                                
%%%%%%%%%%%%%%%% Animation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    if Animation == 1

        transform = transl2(q(1,k),q(2,k)) * trot2(q(3,k)); % original
        transObject(robotObject,transform);
        if k>1
            xPlot = [q(1,k-1); q(1,k)]; % original
            yPlot = [q(2,k-1); q(2,k)]; % original
            patch('XData', xPlot, 'YData', yPlot, 'EdgeColor', 'r')
        end
        drawnow
    end             
    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if flag == 1
        % transforming robot coordinates to world
        Tl = SE2([q(1,k) q(2,k) q(3,k)]);
        center1 = Tl*center_wrt_robot;
        Tl1 = SE2([center1(1) center1(2) q(3,k)]);
        % transforming robot coordinates to world
     
        
        % transforming center-point of robot to world coordinates
        % Tl2 = SE2([center(1) center(2) q(3,k)]);
        TlL = SE2([X(1,k) X(2,k) X(3,k)]);
        center2 = TlL*center_wrt_robot;
        Tl2 = SE2([center2(1) center2(2) X(3,k)]);
       Lsweep = 1;
       while Lsweep<=1
           
           %   p = laserScanner2(angleSpan, angleStep, rangeMax, Tl1.T, bitmap, Xmax, Ymax);

           p = laserScannerNoisy(angleSpan, angleStep, rangeMax, Tl1.T, bitmap, Xmax, Ymax);
           p(:,2) = medfilt1(p(:,2));
           % Laser Beam Grid update
           for i=1:length(p)
               angle = p(i,1); range = p(i,2);
               % handle infinite range
               if(isinf(range))
                   range = rangeMax+1;
                   
               end

               %n = updateLaserBeamBitmap(angle, range, Tl.T, Row, Col, Xmax, Ymax);
               [o,l] = updateLaserBeamGrid(angle, range, Tl2.T, Row, Col, Xmax, Ymax);
           end
           Lsweep = Lsweep + 1;
       end
    end    
        
% This line displays the coordinates of the robot in the output screen
      [q(1,k),q(2,k)]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        
k = k +1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
end

%%%%%%%%%%%

%% Post Processing

X = [Orch.SWcorner(1) Orch.SWcorner(1)+(Orch.K-1)*Orch.w];
Y = [Orch.SWcorner(2)-D/2 Orch.SWcorner(2)+Orch.RL+D/2];


%%%%%%%%%%%%%%%%%%%%% Actual Truth %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
figure
imagesc(bitmap);
set(gca,'Ydir','normal')
axis equal

[I,J] = XYtoIJ([X X],[Y(1) Y(1) Y(2) Y(2)],Xmax,Ymax,ROW,COL);

ylim([I(1) I(3)])
xlim([J(1) J(2)])
set(gca,'visible','off')

RGB = getframe(gcf);
Gray = rgb2gray(RGB.cdata);
BWact = imbinarize(Gray,0.24);
BWact = BWmodification(BWact);

[row,col] = size(BWact);
[centersMain,radiiMain] = imfindcircles(BWact,[5 15], 'Sensitivity',0.95);

figure
imshow(BWact);
h = viscircles(centersMain,radiiMain);

[xTru,yTru] = IJtoXY2(centersMain(:,2),centersMain(:,1),X(2)-X(1),Y(2)-Y(1),row,col);
xTru = xTru + X(1);
yTru = yTru + Y(1);
pixDensity = mean([(X(2)-X(1))/col, (Y(2)-Y(1))/row]);
radiiTru = radiiMain.*pixDensity;
SWcorner = Orch.SWcorner;
SWcorner(1) = SWcorner(1) + Orch.w;
[cTru,radiiTru] = reportOutput([xTru yTru], radiiTru, Orch.w, SWcorner,2);


%%
%%%%%%%%%%%%%% Estimated %%%%%%%%%%%%%%%%%%%%%%%%%

figure('Name','OccGrid')
imagesc(occ_grid);
set(gca,'Ydir','normal')
axis equal

[I,J] = XYtoIJ([X X],[Y(1) Y(1) Y(2) Y(2)],Xmax,Ymax,Row,Col);

ylim([I(1) I(3)])
xlim([J(1) J(2)])
set(gca,'visible','off')

RGB = getframe(gcf);
Gray = rgb2gray(RGB.cdata);
BW = imbinarize(Gray,0.24);

BW = BWmodification(BW);
[row,col] = size(BW);
[centersMain,radiiMain] = imfindcircles(BW,[5 15], 'Sensitivity',0.95);
figure
imshow(BW);
h = viscircles(centersMain,radiiMain);

[x,y] = IJtoXY2(centersMain(:,2),centersMain(:,1),X(2)-X(1),Y(2)-Y(1),row,col);
x = x + X(1);
y = y + Y(1);
pixDensity = mean([(X(2)-X(1))/col, (Y(2)-Y(1))/row]);
radii = radiiMain.*pixDensity;
SWcorner = Orch.SWcorner;
SWcorner(1) = SWcorner(1) + Orch.w;

intersect = circleOverlap([x,y], radii); % checks if circles are overlapping
[c, radii] = circleModification([x,y], radii, intersect, Orch.w); % Removes overlapping circle

[c,radii] = reportOutput(c, radii, Orch.w, SWcorner,1); % Reports output as a file

%%
disp('Press Enter key to obtain final figures');

%% Final Plots
pause;
close all
figure('Name','Path Generated by GA','NumberTitle','off')
plot(theoretical_path(1,:),theoretical_path(2,:),'LineWidth',2)
title('Path Generated by GA')
xlabel('X-Position in meters')
ylabel('Y-Position in meters')
axis square

figure('Name','Path Travelled by Robot','NumberTitle','off')
plot(q(1,1:k-1),q(2,1:k-1),'rx', 'MarkerSize', 1.5);
title('Path Travelled by Robot');
xlabel('X-Position in meters')
ylabel('Y-Position in meters')
axis square

x_im=[0 Xmax]; y_im=[0 Ymax];
figure('Name','Obstacle Estimation','NumberTitle','off')
imagesc(x_im, y_im, occ_grid)
title('Obstacle Estimation')
set(gca,'Ydir','normal')
xlabel('X-Position in meters')
ylabel('Y-Position in meters')
axis equal

figure('Name','Ground Truth of Tree Locations', 'NumberTitle','off')
imagesc(x_im, y_im, bitmap)
title('Ground Truth of Tree Locations')
set(gca,'Ydir','normal')
xlabel('X-Position in meters')
ylabel('Y-Position in meters')
axis equal

figure('Name','Tree Detection After Image Processing','NumberTitle','off')
title('Tree Detection')
h = plot_circle(c(:,1),c(:,2),radii, 'r');
k = plot_circle(cTru(:,1),cTru(:,2),radiiTru, 'b');
xlim([0 Xmax]);
ylim([0 Ymax]);
xlabel('X-Position in meters')
ylabel('Y-Position in meters')
legend([h k],'Estimated','Actual');
axis equal

%%

errorAnalysis(c, radii, cTru, radiiTru);

%%
save('Results.mat','c','cTru','radii','radiiTru','q','t','BW',...
 'Orch','C','pixDensity','Xmax','Ymax','row','Row','ROW','Col','col','COL','bitmap','occ_grid')

