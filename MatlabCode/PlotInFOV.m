% =========================================================================
%
% PlotInFOV.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Shows what star tracker sees in 2-D. Draws line from P1 to P2 in
% star tracker frame. To draw star, set P2 to zero, and
%
% INPUTS:   P1 - vector to point 1
%           P2 - vector to point 2
%           FOV - Star Tracker field of view (rad)
%           clr - clear FOV if 1
%           c - color and style of line
%
% OUTPUT:   none
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

function PlotInFOV( P1, P2, FOV, clr, c )

% Plane will pass through pt P and, and be perpedicular to vector P
% Equation of plane: Ax + By + Cz = D

% Determine equation of plane that will be perpendicular to vector P
% and pass through pt P

P = [1 0 0]';  % Center of FOV in star tracker frame

if clr == 1
    
    figure(2);
    hold off;               
    plot( 0, 0,'+b');
    axis( [ -FOV/2*180/pi FOV/2*180/pi -FOV/2*180/pi FOV/2*180/pi ] );
    hold on;
    
    i = 1;
    for j=0:2*pi/30:2*pi
        x(i) = FOV/2 * 180/pi * cos( j ); 
        y(i) = FOV/2 * 180/pi * sin( j );
        i = i + 1;
    end
    plot( x, y, '-b' );
    
else
    
    A = P(1);
    B = P(2);
    C = P(3);
    D = A^2 + B^2 + C^2;
    
    % Find where vector for star (P1) intersects plane
    
    t = D / ( P(1) * P1(1) + P(2) * P1(2) + P(3) * P1(3) );
    P1a = [ P1(1) * t P1(2) * t P1(3) * t ]';
    
    % Rotate plane about z-axis, then y-axis so its parallel to x-y plane
    
    mag = sqrt( P(1)^2 + P(2)^2 + P(3)^2 );
    beta = pi/2 - asin( P(3) / mag );
    alpha = atan2( P(2), P(1) );
    
    Ry = [ cos(-beta) 0 -sin(-beta); 0 1 0; sin(-beta) 0 cos(-beta)];
    Rz = [ cos(alpha) -sin(alpha) 0; sin(alpha) cos(alpha) 0; 0 0 1];
    
    % P = Ry^-1 * Rz^-1 * P         % Check: should be [0 0 1]'
    
    P1xy = Ry^-1 * Rz^-1 * P1a;      % Results in [x y 1]'
    
    % Second point
    
    % Find where vector for star (P2) intersects plane
    
    t = D / ( P(1) * P2(1) + P(2) * P2(2) + P(3) * P2(3) );
    P2a = [ P2(1) * t P2(2) * t P2(3) * t ]';
    
    % Rotate plane about z-axis, then y-axis so its parallel to x-y plane
    
    P2xy = Ry^-1 * Rz^-1 * P2a;      % Results in [x y 1]'
    
    % Plot
    
    x = [ P1xy(1) P2xy(1) ] .* 180/pi;
    y = [ P1xy(2) P2xy(2) ] .* 180/pi;
    
    figure(2)
    plot( x, y, c );
    
end

