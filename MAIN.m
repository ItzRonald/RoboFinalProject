%% Initialization
clc, clear, close all

% Webcam
list = webcamlist; % Requires webcam addon
cam = webcam(list{1})
pause(1);
cam.Resolution = "1280x720";
Cam_wrt_F5 = [-1, 0, 0,  5;
             0,-1, 0, 30;
             0, 0, 1, 55;
             0, 0, 0,  1 ];
frame = cam.snapshot(); % test

% Socket
Socket_wrt_Tag = [1, 0, 0,  0;
                 0, 1, 0, 25;
                 0, 0, 1,  0;
                 0, 0, 0,  1 ];
approach_vector_wrt_Socket = [0,0,-190]; % mm, target distance of o4 before insertion

% Degrees of freedom (starting at homed position)
DOFs = [0,0,0,0,0,0];


%% STEP 1: Home
DOFs = HOME(DOFs); % All functions that change DOFs return the new values--I do not edit them directly.

%% STEP 2: Inverse kinematic approach to outlet
% Look for AprilTag
frame = cam.snapshot();
tags = DETECT_APRIL_TAGS(frame);

% Wait for tag to appear if there wasn't one
while (tags{1} == 0) || (tags{2}{1} < 50)
    fprintf("No barcode detected. Retrying in 2...\n")

    pause(2)

    frame = cam.snapshot();
    tags = DETECT_APRIL_TAGS(frame);
end

% Now it begins.
fprintf("Barcode %d detected. Starting in 5...\n", tags{2}{2})
pause(5)

tag = tags{2}; % Contains: detection margin, ID#, position in cam, orientation in cam
Tag_wrt_Cam = TAG_WRT_CAM(tag); % Get tag frame in camera frame

% Get target location in front of outlet in F0:
F5_wrt_F0 = MAKE_T(MAKE_A_BLOCK(OWI_REV_LIN_DH_PARAMS(DOFs)),5,0); % Get frame 5 in frame 0
Socket_wrt_F0 = F5_wrt_F0 * Cam_wrt_F5 * Tag_wrt_Cam * Socket_wrt_Tag; % Get socket frame in F0.

target_wrt_F0_AUG = Socket_wrt_F0 * [approach_vector_wrt_Socket,1]'; % Get target location in frame 0

% Calulate joint angles
constants = OWI_REV_LIN_DH_PARAMS([0,0,0,0,0,0]);
d1 = constants(1,3);
r2 = constants(2,1);
r3 = constants(3,1);
r4 = constants(4,1);

xt = target_wrt_F0_AUG(1);
yt = target_wrt_F0_AUG(2);
zt = target_wrt_F0_AUG(3);

t1_target = atan2(yt,xt); % Theta 1

R = (xt^2 + yt^2)^0.5;
r = R - r4;
s = zt - d1;
h = (r^2 + s^2)^0.5;
ca = (r2^2 + h^2 - r3^2)/(2*r2*h);
a = atan2((1 - ca^2)^0.5, ca);

t2_target = -atan2(s,r) - a; % Theta 2, elbow up

cb = (r2^2 + r3^2 - h^2)/(2*r2*r3);
b = atan2((1-cb^2)^0.5, cb);

t3_target = pi - b; % Theta 3, elbow up

t4_target = -(t2_target + t3_target); % Theta 4, levels out t2 and t3.

angle1 = t1_target; % Angle in the F0 xy plane to the target point.
Socket_z_wrt_F0 = Socket_wrt_F0(1:3,3); % Socket z axis in F0
angle2 = atan2(Socket_z_wrt_F0(2), Socket_z_wrt_F0(1)); % Angle of Socket z axis over F0 xy plane.

t5_target = angle2 - angle1 + pi/2;
t5_target = mod(t5_target + pi,2*pi) - pi;


% Move joints.
% First, swing link 5 away from the wall. The tag's z axis will either dot
% positive or negative with the camera's x-axis. The camera x points right,
% and the tag's z points into the wall. If it dots positive, swing
% left. If it dots negative, swing right. Dotting is equivalent to
% extracting the x coordinate.
if (Tag_wrt_Cam(1,3) > 0)
    DOFs(5) = MOVE(5,160);
else
    DOFs(5) = MOVE(5,20);
end

% Now, move the rest in order:
DOFs(1) = MOVE(1,t1_target);
DOFs(2) = MOVE(2,t2_target);
DOFs(3) = MOVE(3,t3_target);
DOFs(4) = MOVE(4,t3_target);
DOFs(5) = MOVE(5,t5_target);

%% More code goes here for precision movements.
