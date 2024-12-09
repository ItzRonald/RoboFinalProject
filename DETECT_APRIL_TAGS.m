function [tags] = DETECT_APRIL_TAGS(im)
% Requires "detect_two_apriltags.py" in same folder. GFYS lol. 4:46 am.

    % SOURCE FILE
    % This could be aquired by a camera--this is just an example.
    % im = imread("three_tags.jpg");
    % END OF SOURCE FILE
    
    % Apriltag detection starts here.
    
    % Write as frame.jpg
    imwrite(im,"frame.jpg");
    % Run Python script ("detect_two_apriltags.py", which accepts "frame.jpg" and writes to the file "apriltag_detections_output.txt")
    pyrunfile("detect_two_apriltags.py");
    % Open extracted data matrix (10x3)
    apriltag_pose_data = readmatrix("apriltag_detections_output.txt");
    
    % Gather tag data
    % Detection margin, puported ID, puported position, puported rotation matrix
    count = apriltag_pose_data(1,1);
    tags = {count};
    if (count > 0)
        tags{end+1} = {apriltag_pose_data(2,2), round(apriltag_pose_data(2,1)), apriltag_pose_data(3,1:3), apriltag_pose_data(4:6,1:3)};
    end
    if (count > 1)
        tags{end+1} = {apriltag_pose_data(7,2), round(apriltag_pose_data(7,1)), apriltag_pose_data(8,1:3), apriltag_pose_data(9:11,1:3)};
    end

end