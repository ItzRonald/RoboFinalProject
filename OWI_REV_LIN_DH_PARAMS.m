function [dh_parameter_table] = OWI_REV_LIN_DH_PARAMS(DOFs)
% Returns a filled-out DH parameter table for the robot in a fixed configuration.
% Can be used to make A-matrix blocks, which are in turn used to make T matrices.

    % Free parametes of robot
    t1 = DOFs(1);
    t2 = DOFs(2);
    t3 = DOFs(3);
    t4 = DOFs(4);
    t5 = DOFs(5);
    d6 = DOFs(6);

    % Fixed parameters of robot (hardcoded, millimeters):
    a1 = -pi/2 - pi/180*1.5; % extra 1.5 degrees that we measured
    d1 = 70;
    r2 = 90;
    r3 = 110;
    r4 = 27;

    dh_parameter_table = [  0,   a1, d1, t1;
                           r2,    0,  0, t2;
                           r3,    0,  0, t3;
                           r4, pi/2,  0, t4;
                            0, pi/2,  0, t5;
                            0,    0, d6,  0 ];
end