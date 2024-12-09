function [T] = MAKE_T(A_block,frame,in_frame)
% Give homogeneous transformation matrix T of frame "frame" with respect to 
% frame "in_frame."

reverse = false;
sup = in_frame;
sub   = frame;

% If it asks for a lower frame in terms of a higher frame, it will invert
% at end.
if (in_frame > frame)
    reverse = true;
    sup = frame;
    sub   = in_frame;
end

% Start as an eye-dentity matrix
T = eye(4);

% T sub i sup n equals A_(n+1)...A_i.
for m = (sup+1):sub
    T = T * A_block(:,:,m);
end

% If it asks for a lower frame in terms of a higher frame, invert it.
if reverse
    T = invert_homogeneous_matrix(T);
end