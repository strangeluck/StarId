% =========================================================================
%
% CoordXform.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Transforms point in cartesian from one frame to another
%
% INPUTS:   vi - vector in intertial frame
%           b  - body frame (unit vectors in inertial frame)
%
% OUTPUT:   vb - vector in body frame
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

function vb = CoordXform( vi, bframe );

% Make axis of frames easier to see

i1 = [ 1 0 0 ]';
i2 = [ 0 1 0 ]';
i3 = [ 0 0 1 ]';

b1 = bframe.b1;
b2 = bframe.b2;
b3 = bframe.b3;

% Create Rotation Matrix

l1 = dot( i1, b1 );
l2 = dot( i1, b2 );
l3 = dot( i1, b3 );

m1 = dot( i2, b1 );
m2 = dot( i2, b2 );
m3 = dot( i2, b3 );

n1 = dot( i3, b1 );
n2 = dot( i3, b2 );
n3 = dot( i3, b3 );

R = [ l1 l2 l3; m1 m2 m3; n1 n2 n3 ];

% Determine new v in b coordinates

vb = R'*vi;