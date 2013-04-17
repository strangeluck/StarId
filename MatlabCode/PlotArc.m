% =========================================================================
%
% PlotArc.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Plots node in current figure, using arcs
%
% INPUTS:   p1  unit vector to starting point
%           p2  unit vector to ending point
%           c   color
%
% OUTPUT:   none
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

function PlotArc( p1, p2, c );

% Find normal to plane created by vectors P1 and P2

P = cross( p1, p2 );
beta = asin( P(3)/ sqrt(P(1)^2+P(2)^2+P(3)^2) );
alpha = atan2( P(2),P(1) ); 

% First rotate about z-axis, then y-axis to get plane by vectors coplaner
% to x-y axis.

Rz1 = [ cos(alpha) -sin(alpha) 0; sin(alpha) cos(alpha) 0; 0 0 1];
Ry = [ cos(beta-pi/2) 0 -sin(beta-pi/2); 0 1 0; sin(beta-pi/2) 0 cos(beta-pi/2)];

p1a = Ry^-1 * Rz1^-1 * p1;
p2a = Ry^-1 * Rz1^-1 * p2;

% Rotate about z-axis again to get pt 1 to x-axis

theta1 = atan2( p1a(2), p1a(1) );

Rz2 = [ cos(theta1) -sin(theta1) 0; sin(theta1) cos(theta1) 0; 0 0 1];

p1b = Rz2^-1 * p1a;
p2b = Rz2^-1 * p2a;

% Create arc from pt 1 to pt 2 on xy plane

theta2 = atan2( p2b(2), p2b(1) );

% if theta2>0               % Use for fixed arc per step
%     step = 1 * pi/180;
% else
%     step = -1 * pi/180;
% end

step = theta2 / 10;         % Use for fixed steps per arc

npt = 0;
for i=0:step:theta2
    npt = npt + 1;
    ptb(1,npt) = 1*cos(i);
    ptb(2,npt) = 1*sin(i);
    ptb(3,npt) = 0;
end

% Rotate arc back to vectors' original orientation

for i=1:npt
    pt(:,i) = Rz1 * Ry * Rz2 * ptb(:,i);
end

% Plot

plot3( pt(1,:), pt(2,:), pt(3,:), c ); 