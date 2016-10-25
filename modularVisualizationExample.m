%% initialize parameters
b = 0.6;
a = 0.08;
dt = 0.03;
pauseTime = 0.00001;
tailLength = 5;
xlimits = [-2,2];
ylimits = [-2,2];
flowFieldSpacing = 0.1; % spacing of grid to build flow field on
flowFieldDecayLength = 10.0; % as one moves away from the fixed point, may the quiver points less visually important
howCloseToFixedPoint = 1.5; % standard deviation in starting position
%% calculate the dynamics for a system that starts at an arbitrary position
% x0,y0

% setup anonymous functions to calculate the derivatives
ydot = @(x,y) x.^2 + y.^2 + x + y;
xdot = @(x,y) -3*x;

% proceed in one time step using Euler integration
counter  = 1;

% xFix = b;
% yFix = b/(b+a^2);

yFix = -1;
xFix = 0;

x0 = xFix+randn(1)*howCloseToFixedPoint;
y0 = yFix+randn(1)*howCloseToFixedPoint;
xNew = x0;
yNew = y0;


% setup vectors to hold position of "tail"
tailX = repmat(x0,tailLength,1);
tailY = repmat(y0,tailLength,1);

% flow field
[xx,yy] = meshgrid(xlimits(1):flowFieldSpacing:xlimits(2),ylimits(1):flowFieldSpacing:ylimits(2));

[theta,r] = cart2pol(xx-xFix,yy-yFix);
xx(r>flowFieldDecayLength) = nan;
yy(r>flowFieldDecayLength) = nan;

% start with a blank graph
clf;
hold on;

% plot flow field as quiver
quiver(xx(:),yy(:),xdot(xx(:),yy(:)),ydot(xx(:),yy(:)),3);

% save plotting handle to improve speed and smoothness
pHand = plot(xNew,yNew,'r*','linewidth',2,'markersize',10);
 % patchline, from the file exchange has this tendency to link the first
 % and last points together, add in an extra element of "nans" to remove
 % this
alphaData = repmat(tailLength./[1:(tailLength+1)],1);
alphaData = (alphaData(:));
alphaData = alphaData.^(-2);
tailHand = patchline([tailX;nan],[tailY;nan],'edgecolor','b','LineWidth',2,...
    'EdgeAlpha','interp',...
    'FaceVertexAlphaData',alphaData);

% add in a cross at the fixed point
plot(xFix,yFix,'kx','linewidth',2);
plot(xFix,0,'ks','linewidth',2);



% set plotting limits to remain the same
xlim(xlimits);
ylim(ylimits);

% keep dropping new spots in
x0 = xFix+randn(1)*howCloseToFixedPoint;
y0 = yFix+randn(1)*howCloseToFixedPoint;
xNew = x0;
yNew = y0;


% setup vectors to hold position of "tail"
tailX = repmat(x0,tailLength,1);
tailY = repmat(y0,tailLength,1);

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
    set(tailHand,'xData',[tailX;nan],'yData',[tailY;nan]);
    
    title(num2str(counter));
    
    % move on to the next time step
    counter = counter+1;
end
