function [A_block] = MAKE_A_BLOCK(DH_parameter_table)
% Takes in a matrix of DH parameter rows (each [r, alpha, d, theta]) and
% compiles them into a 3d matrix of corresponding A matrices.
%   The 1st 4x4 slice is the transform from the frame 0 to frame 1.
%   The 2nd 4x4 slice is the transform from frame 1 to frame 2.
%   The 3rd 4x4 slice...
rows = size(DH_parameter_table,1);

A_block = zeros([4,4,rows]);

for i = 1:rows
    A_block(:,:,i) = MAKE_A(DH_parameter_table(i,:));
end

end