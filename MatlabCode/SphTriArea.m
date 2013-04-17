% =========================================================================
%
% SphTriArea.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Calculates the area of a spherical triangle with unit radius
%
% INPUTS:   v1 - unit vector to vertex 1
%           v2 - unit vector to vertex 2
%           v3 - unit vector to vertex 3
%
% OUTPUT:   A - area
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

function A = SphTriArea( v1, v2, v3 );

% Assumes points are on a sphere, with a radius of 1

a = acos( dot( v1, v2 ) / 1 );
b = acos( dot( v2, v3 ) / 1 );
c = acos( dot( v3, v1 ) / 1 );
s = (a+b+c)/2;

A = 4*atan( sqrt( tan(s/2)*tan((s-a)/2)*tan((s-b)/2)*tan((s-c)/2) ) );