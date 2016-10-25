%% initialize parameters
b = 0.6;
a = 0.08;
dt = 0.1;

%% calculate the dynamics for a system that starts at an arbitrary position
% x0,y0

% setup anonymous functions to calculate the derivatives
ydot = @(x,y) -y*x^2 + b - a*y;
xdot = @(x,y) y*x^2 - x + a*y;

% proceed in one time step using Euler integration
xNew = x0 + dt*xdot(x0,y0);
yNew = y0 + dt*ydot(x0,y0);

