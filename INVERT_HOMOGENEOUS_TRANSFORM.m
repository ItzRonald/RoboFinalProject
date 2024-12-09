function [inverted_homogeneous_matrix] = INVERT_HOMOGENEOUS_TRANSFORM(homogeneous_matrix)
% Inverts homogeneous matrix without invoking complex numerical methods.
    inverted_homogeneous_matrix = eye(4);
    inverted_homogeneous_matrix(1:3,1:3) = homogeneous_matrix(1:3,1:3)';
    inverted_homogeneous_matrix(1:3,4) = -inverted_homogeneous_matrix(1:3,1:3)*homogeneous_matrix(1:3,4);
end