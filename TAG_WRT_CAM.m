function [tag_in_cam] = TAG_WRT_CAM(tag)
% Converts tag info into a homogenous matrix for convenience

    tag_in_cam = eye(4);
    tag_in_cam(1:3,1:3) = tag{4};
    tag_in_cam(1:3,  4) = tag{3};
    
end