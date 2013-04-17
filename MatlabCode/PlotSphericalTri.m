% =========================================================================
%
% PlotSphericalTri.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Plots spherical triangle given unit vectors poining to vertices
%
% INPUTS:   v1 - vector to first vertex
%           v2 - vector to second vertex
%           v3 - vector to third vertex
%           c - color
%
% OUTPUT:   none
%
% SUBROUTINES REQUIRED: PlotSphericalArc.m
%
% =========================================================================

function PlotSphericalTri( v1, v2, v3, c )

PlotArc( v1, v2, c);
hold on;
PlotArc( v2, v3, c);
PlotArc( v3, v1, c);