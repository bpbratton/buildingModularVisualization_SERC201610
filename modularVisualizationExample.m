%% initialize parameters
b = 0.6;
a = 0.08;
dt = 0.03;
pauseTime = 0.00001;
tailLength = 5;
xlimits = [-0.6,0.6];
ylimits = [-2,1];
flowFieldSpacing = 0.03; % spacing of grid to build flow field on
flowFieldDecayLength = 10.0; % as one moves away from the fixed point, may the quiver points less visually important
howCloseToFixedPoint = 1.5; % standard deviation in starting position
nSpots = 5;
T = 100;

%% calculate the dynamics for a system that starts at an arbitrary position
% x0,y0

% setup anonymous functions to calculate the derivatives
ydot = @(x,y) x.^2 + y.^2 + x + y;
xdot = @(x,y) -3*x;

% proceed in one time step using Euler integration
counter  = 1;

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

% add in a cross at the fixed point
plot(xFix,yFix,'kx','linewidth',2);
plot(xFix,0,'ks','linewidth',2);




% set plotting limits to remain the same
xlim(xlimits);
ylim(ylimits);

for kkSpot = 1:nSpots
% keep dropping new spots in
xNew(1,kkSpot) = rand(1)*diff(xlimits)+xlimits(1);
yNew(1,kkSpot) = rand(1)*diff(ylimits)+ylimits(1);
end
% setup vectors to hold position of "tail"
tailX = repmat(xNew,tailLength,1);
tailY = repmat(yNew,tailLength,1);
for kkSpot = 1:nSpots
tailHand(kkSpot) = patchline([tailX(:,kkSpot);nan],[tailY(:,kkSpot);nan],'edgecolor','b','LineWidth',2,...
    'EdgeAlpha','interp',...
    'FaceVertexAlphaData',alphaData);
end
%
% loop over a few frames
ticA = tic;
while toc(ticA) < 3
    
    % calculate the new position
    xNew = xNew + dt*xdot(xNew,yNew);
    yNew = yNew + dt*ydot(xNew,yNew);
    
    % plot the new position
    set(pHand,'xData',xNew,'yData',yNew);
    figure(gcf);pause(pauseTime);
    
    for kkSpot = 1:nSpots

    % update the tail coordinates
    tailX(:,kkSpot) = [tailX(2:end,kkSpot);xNew(kkSpot)];
    tailY(:,kkSpot) = [tailY(2:end,kkSpot);yNew(kkSpot)];
    set(tailHand,'xData',[tailX(:,kkSpot);nan],...
        'yData',[tailY(:,kkSpot);nan]);
    end
    title(num2str(counter));
    
    % move on to the next time step
    counter = counter+1;
end
