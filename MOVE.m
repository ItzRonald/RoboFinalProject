function [parameter] = MOVE(DOF_idx,parameter)
    fprintf("Moving joint %d to position %f.\n", [DOF_idx, parameter])
    pause(0.2)
end