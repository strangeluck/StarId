% =========================================================================
%
% InitNodes.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Initializes first level nodes in quad-tree. Results is a spherical
% tetrahedron.
%
% INPUTS:   none
%
% OUTPUT:   none
%
% SUBROUTINES REQUIRED: SearchDist.m
%                       PlotNode.m
%
% =========================================================================

% Notice that search distance is subtracted from pi because the starting
% triangles have angles greater than 90 degrees.

global Node nNodes gmode

Vx1V = Vertex( 1 ).Vector;
Vx2V = Vertex( 2 ).Vector;
Vx3V = Vertex( 3 ).Vector;
Vx4V = Vertex( 4 ).Vector;

% Node 1

Node(1).Parent = 0;
Node(1).Vertex = [ 1 2 3 ];
Node(1).Children = [];
Node(1).Stars = [];
Node(1).Level = 1;

if gmode ~= 0
    PlotNode( 1,'r' );
end
Node(1).SDist = pi - SearchDist( Vx1V, Vx2V, Vx3V );

% Node 2

Node(2).Parent = 0;
Node(2).Vertex = [ 1 3 4 ];
Node(2).Children = [];
Node(2).Stars = [];
Node(2).Level = 1;

if gmode ~= 0
    PlotNode( 2, 'r' );
end
Node(2).SDist = pi - SearchDist( Vx1V, Vx3V, Vx4V );

% Node 3

Node(3).Parent = 0;
Node(3).Vertex = [ 1 4 2 ];
Node(3).Children = [];
Node(3).Stars = [];
Node(3).Level = 1;

if gmode ~= 0
    PlotNode( 3, 'r' );
end
Node(3).SDist = pi - SearchDist( Vx1V, Vx4V, Vx2V );

% Node 4

Node(4).Parent = 0;
Node(4).Vertex = [ 4 3 2 ];
Node(4).Children = [];
Node(4).Stars = [];
Node(4).Level = 1;

if gmode ~= 0
    PlotNode( 4, 'r');
end
Node(4).SDist = pi - SearchDist( Vx4V, Vx3V, Vx2V );

nNodes = 4;