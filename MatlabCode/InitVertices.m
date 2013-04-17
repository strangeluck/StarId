% =========================================================================
%
% InitVertices.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Initializes first level vertices in quad-tree. Locations of vertices
% results in a sherical tetrahedron
%
% INPUTS:   none
%
% OUTPUT:   none
%
% SUBROUTINES REQUIRED: SearchDist.m
%                       PlotNode.m
%
% =========================================================================

global Vertex nVertex gmode

nVertex = 4;

% Tetrahedron, circumradius=1, centroid at (0,0,0)

R = 1;
a = 4 * R / sqrt(6);
x = sqrt(3)/3 * a;
r = sqrt(6)/12 * a;
d = sqrt(3)/6 * a;
% h = sqrt(6)/3 * a

% First four vertexes form a (spherical) tetrahedron

Vertex(1).Vector = [ 0 0 R ]';
Vertex(1).Neighbor = [];
Vertex(1).Child = [];
Vertex(1).Nodes = [];

Vertex(2).Vector = [ x 0 -r ]';
Vertex(2).Neighbor = [];
Vertex(2).Child = [];
Vertex(2).Nodes = [];

Vertex(3).Vector = [ -d a/2 -r ]';
Vertex(3).Neighbor = [];
Vertex(3).Child = [];
Vertex(3).Nodes = [];

Vertex(4).Vector = [ -d -a/2 -r ]';
Vertex(4).Neighbor = [];
Vertex(4).Child = [];
Vertex(4).Nodes = [];

% Plot if desired

if gmode ~= 0
    for i=1:4
        plot3( Vertex(i).Vector(1), Vertex(i).Vector(2), ...
            Vertex(i).Vector(3),'ob','MarkerSize',7);        
    end
end

