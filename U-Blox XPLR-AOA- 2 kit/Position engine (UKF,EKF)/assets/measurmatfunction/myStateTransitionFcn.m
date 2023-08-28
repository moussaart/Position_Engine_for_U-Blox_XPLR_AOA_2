function xhat=myStateTransitionFcn(x)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
dt=1/1000;
F=[ 1 dt 0 0;0 1 0 0; 0 0 1 dt; 0 0 0 1];
xhat=F*x;
end

