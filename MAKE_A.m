function [A] = MAKE_A(DH_parameters)
% Takes in an 1x4 matrix with [r,alpha,d,theta] and generates an A 
% homogenous transform matrix according to DH parameterization convention.

r = DH_parameters(1);
a = DH_parameters(2);
d = DH_parameters(3);
t = DH_parameters(4);

A = [cos(t), -sin(t)*cos(a),  sin(t)*sin(a), r*cos(t);
     sin(t),  cos(t)*cos(a), -cos(t)*sin(a), r*sin(t);
          0,         sin(a),         cos(a),        d;
          0,              0,              0,        1];

end