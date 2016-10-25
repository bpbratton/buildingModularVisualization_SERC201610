%% initialize parameters
b = 0.6;
a = 0.08;
dt = 0.01;

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

% save plotting handle to improve speed and smoothness
pHand = plot(xNew,yNew,'r*','linewidth',2,'markersize',10);

% set plotting limits to remain the same
xlim([0,3]);
ylim([0,3]);
hold on;

% loop over a few frames
while counter < 100
    xNew = xNew + dt*xdot(xNew,yNew);
    yNew = yNew + dt*ydot(xNew,yNew);
    set(pHand,'xData',xNew,'yData',yNew);
    figure(gcf);pause(0.1);
    counter = counter+1;
end
