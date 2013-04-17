% =========================================================================
%
% CalcFOV.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Determines the field of view required to see spherical triangle
%
% INPUTS:   p1 - vector of triangle vertex no. 1
%           p2 - vector of triangle vertex no. 2
%           p3 - vector of triangle vertex no. 3
%
% OUTPUT:   alpha - diameter of required field of view (rads)
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

function alpha = CalcFOV( p1, p2, p3 )

% Point is also the vector from the origin to the point.

% Vector r from each pt to another pt. Length of each r is a side of a triangle

r12 = p2 - p1;
r23 = p3 - p2;
r31 = p1 - p3;

% Calc length of vector from pt to pt

a = sqrt( r12(1)^2 + r12(2)^2 + r12(3)^2 );
b = sqrt( r23(1)^2 + r23(2)^2 + r23(3)^2 );
c = sqrt( r31(1)^2 + r31(2)^2 + r31(3)^2 );

% Determine interior angles of triangle

A = acos( (b^2 + c^2 - a^2)/(2*b*c) );
% A*180/pi
B = acos( (a^2 + c^2 - b^2)/(2*a*c) );
% B*180/pi
C = acos( (a^2 + b^2 - c^2)/(2*b*a) );
% C*180/pi

% If all the angles within the triangle are less than 90 degrees, the field of
% view is deterimned by drawing a circle through the three pts

% If any angle is greater than 90 degrees, the field of view is determined
% by the greatest distance from any pt to another.

r = 0;

if max( [ A B C ] ) < (pi/2)
    
    % CalcFOV determines the field of view occupied by three pts on a sphere
    % p1, p2 and p3 are arrays: [ x y z ]
    
    % Distance to center from pt 1 to pt 2 must be equal (eq 1)
    
    A1(1) = - 2*p1(1) + 2*p2(1);
    A1(2) = - 2*p1(2) + 2*p2(2);
    A1(3) = - 2*p1(3) + 2*p2(3);
    B(1) = - (p1(1)^2 + p1(2)^2 + p1(3)^2) + (p2(1)^2 + p2(2)^2 + p2(3)^2);
    
    % Distance to center from pt 2 to pt 3 must be equal (eq 2)
    
    A2(1) = - 2*p2(1) + 2*p3(1);
    A2(2) = - 2*p2(2) + 2*p3(2);
    A2(3) = - 2*p2(3) + 2*p3(3);
    B(2) = - (p2(1)^2 + p2(2)^2 + p2(3)^2) + (p3(1)^2 + p3(2)^2 + p3(3)^2);
    
    % All points must be on the same plane (eq 3)
    
    P = [ -p1'; p2'-p1'; p3'-p1' ];
    
    A3(1) = ( P(2,2) * P(3,3) ) - ( P(2,3) * P(3,2) );
    A3(2) = ( P(2,3) * P(3,1) ) - ( P(2,1) * P(3,3) );
    A3(3) = ( P(2,1) * P(3,2) ) - ( P(2,2) * P(3,1) );
    B(3) = - det( P );
    
    A = [ A1; A2; A3 ];
    
    x = inv(A)*B';
    
    r = sqrt( (p1(1)-x(1))^2 + (p1(2)-x(2))^2 + (p1(3)-x(3))^2 );         
    
else
    
    r = max( [a b c] )/2; % Make negative to indicate "skinny"
    
end

% FOV is twice the angle formed by triangle with opp=r and hyp=1

alpha = [ 2*asin(r/1) ];
% alpha*180/pi
