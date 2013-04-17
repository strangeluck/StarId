% =========================================================================
%
% SphTriCentroid.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Calculates the centroid of a spherical triangle with unit radius
%
% INPUTS:   v1 - unit vector to vertex 1
%           v2 - unit vector to vertex 2
%           v3 - unit vector to vertex 3
%
% OUTPUT:   c - unit vector to centroid
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

function c = SphTriCentroid( v1, v2, v3 )

c = v1 + v2 + v3;
c = c ./ 3;
c = c / norm(c);