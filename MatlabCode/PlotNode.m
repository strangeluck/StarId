% =========================================================================
%
% PlotNode.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Plots node in current figure, using arcs
%
% INPUTS:   n - Node Number
%           c - color
%
% OUTPUT:   none
%
% SUBROUTINES REQUIRED: PlotArc.m
%
% =========================================================================

function PlotNode( n, c );

global Vertex Node

v1 = Vertex( Node(n).Vertex(1) ).Vector;
v2 = Vertex( Node(n).Vertex(2) ).Vector;
v3 = Vertex( Node(n).Vertex(3) ).Vector;

PlotArc( v1, v2, c);
hold on;
PlotArc( v2, v3, c);
PlotArc( v3, v1, c);