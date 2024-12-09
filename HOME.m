function [DOFs] = HOME(DOFs)
% Returns robot to home position.
% Occurs on power up and task completion.

% Home prismatic (6).
DOFs(6) = MOVE(6,  180); % mm

% Home (1) (2) (3) (4) (5).
DOFs(1) = MOVE(1,    0); % deg...
DOFs(2) = MOVE(2, -130);
DOFs(3) = MOVE(3,   90);
DOFs(4) = MOVE(4,   40);
DOFs(5) = MOVE(5,   90);

end