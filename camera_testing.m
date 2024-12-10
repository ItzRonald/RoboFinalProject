% Initialize webcam
list = webcamlist
cam = webcam(list{1})
pause(1);
cam.Resolution = "640x480"
cam.Resolution = "1280x720"

im = cam.snapshot(); % test

% Webcam (with extra lenses) parameters (units in mm)
% oc = 665;
% or = 350;
% fx = 705.5;
% fy = 693.0;

% AprilTag size
tagsize = 37; % mm

% Line drawing settings
axes_length = 18.5; % mm
socket_wrt_Tag = [0,42,0]; % mm
target_wrt_Tag = -socket_wrt_Tag + [0,0,-190];

% Camera imaging loop
while (1)
    % Take image, scan, and display
    im = cam.snapshot();
    tags = DETECT_APRIL_TAGS(im);
    imshow(im);

    % If there is a tag, and it is within detection margin,
    if (tags{1} > 0) && (tags{2}{1} > 50)

        % Extract information from the returned value
        ID = tags{2}{2};
        LOC = tags{2}{3};
        ROT = tags{2}{4};
        
        % Make the tag-with-respect-to-camera frame
        Tag_wrt_Cam = eye(4);
        Tag_wrt_Cam(1:3,1:3) = ROT;
        Tag_wrt_Cam(1:3,4) = LOC;

        % Find points of interest
        x_axis_tip_AUG = Tag_wrt_Cam * [axes_length,0,0, 1]';
        y_axis_tip_AUG = Tag_wrt_Cam * [0,axes_length,0, 1]';
        z_axis_tip_AUG = Tag_wrt_Cam * [0,0,axes_length, 1]';
        socket_loc_AUG = Tag_wrt_Cam * [socket_wrt_Tag, 1]';
        target_loc_AUG = Tag_wrt_Cam * [target_wrt_Tag, 1]';

        % Project them into camera pixel coordinates
        o_PROJ          = project_to_webcam_with_lenses_image(LOC);
        x_axis_tip_PROJ = project_to_webcam_with_lenses_image(x_axis_tip_AUG(1:3));
        y_axis_tip_PROJ = project_to_webcam_with_lenses_image(y_axis_tip_AUG(1:3));
        z_axis_tip_PROJ = project_to_webcam_with_lenses_image(z_axis_tip_AUG(1:3));
        socket_loc_PROJ = project_to_webcam_with_lenses_image(socket_loc_AUG(1:3));
        target_loc_PROJ = project_to_webcam_with_lenses_image(target_loc_AUG(1:3));

        % Draw them on image
        hold on
        drawline('Position',[o_PROJ;x_axis_tip_PROJ],'Color','red','MarkerSize',0.1);
        hold off
        drawline('Position',[o_PROJ;y_axis_tip_PROJ],'Color','green','MarkerSize',0.1);
        drawline('Position',[o_PROJ;z_axis_tip_PROJ],'Color','blue','MarkerSize',0.1);
        drawcircle("Center",socket_loc_PROJ,"Radius",5,'Color','yellow','FaceAlpha',1,'StripeColor','black','MarkerSize',0.1,'LineWidth',1);
        %drawcircle("Center",target_loc_PROJ,"Radius",5,'Color','magenta','FaceAlpha',1,'StripeColor','black','MarkerSize',0.1,'LineWidth',1);

    end
    %pause(0.0);
end

