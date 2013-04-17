% =========================================================================
%
% GetBodyFrame.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Returns random body frame such that b1 is colinear to v
%
% INPUTS:   v - vector for frame to be aligned
%
% OUTPUT:   bframe - 3x3 matrix, first col is b1, 2nd is b2 and 3rd is b3
%                    each is a vector in inertial frame
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

function bframe = GetBodyFrame( v );

b1 = v;       % b1 aligned with v

br = b1;
while norm( cross( b1,br ) ) == 0  % Repeat until not nearly colinear 
    br = GetRandomVector;    % Random vector
end

% b2 = b1 x br = random vector at right angle to b1

b2 = cross( b1, br );       
b2 = b2 / norm( b2 );

% b3 = b1 x b2 = vector rt angle to b1 and b2

b3 = cross( b1, b2 );
b3 = b3 / norm( b3 );

bframe.b1 = b1;
bframe.b2 = b2;
bframe.b3 = b3;