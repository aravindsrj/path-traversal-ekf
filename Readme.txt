Problem introduction:

A tree and plant nursery has a field block with K rows of trees.
Tree rows are aligned in a North-South direction, are 20 m long, 
and are spaced 3m apart from each other. The southern mid-point
of the west row is at 20m, 20m. Trees are of various ages (trunk diameters).  
Some trees may be missing from the row, because  they  were removed for sale,
or due to disease or other damage.


Broad Tasks:

-> Program a mobile robot equpped with GPS, a digital compass, and
   a 2D laser scanner to traverse the field block and count the number
   of trees in each row. 
-> Estimate diameter of the trunk of each tree so that management
   can decide which trees are ready for the market.


Implementation:

-> EKF implemented for robot state estimation using an odometry
   model and GPS-compass sensor. A filter is also implemented for
   the laser.
-> Orchard traversal (the map is accessed only through the noisy 
   sensors).
-> Trees detected and localized; their diameters estimated. They
   are then output as a report giving description of each row
   and number of trees.
-> Error histograms of tree positions and diameters calculated


Inputs:

-> A MATLAB function robot_odo.p that models a mobile robot as a 
   bicycle model with steering and speed first order closed-loop
   dynamics. The function integrates the model for time DT with 
   integration interval dT (global variable), and returns the new
   state (vector [x y θ γ v]) and a noisy estimate of the odometry,
   i.e., a vector [δd+vd δθ+vθ].
-> A MATLAB function LaserScannerNoisy.p. This function will return 
   range measurements that are noisy; they contain white gaussian 
   noise and spike-type noise (due to laser reflections). When a 
   reading is out of range, Inf is returned.
-> MATLAB function GPS_CompassNoisy.p. This function receives as 
   arguments the true pose of the robot and returns a noisy pose, 
   thus emulating real sensors. Also, the GPS and compass provide
   fresh measurements every 1 second. However, the control system 
   operates at a rate of DT=100 ms. So, readings are available once
   every 10 control intervals.
-> A MATLAB function that generates a 2D grid/bitmap with trees 
   (ground truth). The robot is not allowed to access this grid 
   directly, but ONLY through its lidar sensor.


Robot:

-> Ackermann steered vehicle
	Wheelbase = 3m
	Width = 2m
	Maximum steering angle = 55 degrees
	Steering lag = 0.1s
	Velocity lag = 0.2s
-> Robot is positioned initially at 0,0 facing North
-> 2D Lidar has 20m maximum range, 180 degree scanning angle 
   and 1.25 degree angular resolution
	  

Other General Notes:

-> ‘main.m’ should be run to test the program.
-> ‘File2Bitmap.m’ should be run to generate bitmap from output file.
-> There will be a ‘reportOutput.txt’ folder created at the end of each
   program which has information about all the perceived tree centers 
   and their radii.
-> The actual centers and radii that are used for error analysis are 
   obtained from image processing of the bitmap image and NOT from the 
   ‘generatenursery’ function.
-> While running the program, the x and y coordinates of the robot are 
   displayed at each iteration in the command window. If these points
   are compared with the theoretical path of the robot (obtained as a 
   figure), it helps to know how much longer it would take the simulation
   to run.