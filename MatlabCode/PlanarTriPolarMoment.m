% =========================================================================
%
% PlanarTriPolarMoment.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING TRIANGLES
% Craig L Cole
% 12 January 2004
%
% Calculates the polar moment of a planar triangle unit about its centroid
% given the vectors to its vertices
%
% INPUTS:   v1 - unit vector to vertex 1
%           v2 - unit vector to vertex 2
%           v3 - unit vector to vertex 3
%           MaxLevel - level of recursion (recommend 3 minimum)
%           gc - global centroid (ignored on entry)
%           level - current level of recursion (set to 0 when calling)
%
% OUTPUT:   Ip - Polar Moment of Spherical Triangle
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

function Ip = PlanarTriPolarMoment( v1, v2, v3 )

a = norm( v1 - v2 );
b = norm( v2 - v3 );
c = norm( v3 - v1 );

s = (a+b+c)/2;

Area = sqrt( s * (s-a) * (s-b) * (s-c) );

Ip = Area * (a^2 + b^2 + c^2) / 36;