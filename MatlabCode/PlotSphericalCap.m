% =========================================================================
%
% PlotSphericalCap.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Plots a circle centered at point v1 that has a cap angle of gamma.
%
% INPUTS:   v - vector to center of cap
%           gamma - cap angle
%           c - color of cap
%
% OUTPUT:   none
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

function PlotSphericalCap( v, gamma, c )

x = v(1);
y = v(2);
z = v(3);

beta =  pi/2 - acos( z/norm(v) );
alpha = atan2( y, x );

% Plot a sphere on x-y plane

R = sin(gamma/2);
X = cos(gamma/2);

nsegs = 20;

% Create circle on y-z plane, out on x-axis

n = 0;
for theta=0:2*pi/nsegs:2*pi
    n = n + 1;
    Pt(1,n) = X;
    Pt(2,n) = R*cos(theta);
    Pt(3,n) = R*sin(theta);
end    
   
% Rotate to Vector

Ry = [ cos(-beta) 0 -sin(-beta); 0 1 0; sin(-beta) 0 cos(-beta)];
Rz = [ cos(-alpha) -sin(-alpha) 0; sin(-alpha) cos(-alpha) 0; 0 0 1];

for i=1:n
    Pt(:,i) = Rz^-1 * Ry^-1 * Pt(:,i);
end

plot3( Pt(1,:), Pt(2,:), Pt(3,:), c ); 