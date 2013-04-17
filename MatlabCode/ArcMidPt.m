% =========================================================================
%
% ArcMidPt.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Returns unit vector to midpoint of arc between two vectors
%
% INPUTS:   v1 - vector 1
%           v2 - vector 2
%
% OUTPUT:   m - vector pointing to midpoint of arc between v1 and v2
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

function m = ArcMidPt( v1, v2 );

r = v2 - v1;

m = v1 + r ./ 2;

m = m / norm(m);