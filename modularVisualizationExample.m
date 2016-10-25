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
counter  = 1;
x0 = 2;
y0 = 1;
xNew = x0;
yNew = y0;
% loop over a few frames
while counter < 10
    xNew = xNew + dt*xdot(xNew,yNew);
    yNew = yNew + dt*ydot(xNew,yNew);
    plot(xNew,yNew,'rx');
    figure(gcf);pause(0.1);
    counter = counter+1;
end
