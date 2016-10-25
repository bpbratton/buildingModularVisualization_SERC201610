%% initialize parameters
b = 0.6;
a = 0.08;
dt = 0.01;
pauseTime = 0.01;
tailLength = 25;
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
% setup vectors to hold position of "tail"
tailX = repmat(x0,tailLength,1);
tailY = repmat(y0,tailLength,1);

% start with a blank graph
clf;

% save plotting handle to improve speed and smoothness
pHand = plot(xNew,yNew,'r*','linewidth',2,'markersize',10);
hold on;
tailHand = plot(tailX,tailY,'b','linewidth',2);

% set plotting limits to remain the same
xlim([0,3]);
ylim([0,3]);

% loop over a few frames
while counter < 100
    % calculate the new position
    xNew = xNew + dt*xdot(xNew,yNew);
    yNew = yNew + dt*ydot(xNew,yNew);
    
    % plot the new position
    set(pHand,'xData',xNew,'yData',yNew);
    figure(gcf);pause(pauseTime);
    
    % update the tail coordinates
    tailX = [tailX(2:end);xNew];
    tailY = [tailY(2:end);yNew];
    set(tailHand,'xData',tailX,'yData',tailY);
    
    % move on to the next time step
    counter = counter+1;
end
