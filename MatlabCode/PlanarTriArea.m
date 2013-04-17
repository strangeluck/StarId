% =========================================================================
%
% PlanarTriArea.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING TRIANGLES
% Craig L Cole
% 12 January 2004
%
% Calculates the area of a planar triangle given vectors pointing to
% vertices.
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

function Area = PlanarTriArea( v1, v2, v3 );

a = norm( v1 - v2 );
b = norm( v2 - v3 );
c = norm( v3 - v1 );

s = (a+b+c)/2;

Area = sqrt( s * (s-a) * (s-b) * (s-c) );