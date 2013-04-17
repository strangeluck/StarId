% =========================================================================
%
% AddChildren.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Creates four new nodes for parent node
%
% INPUTS:   n - parent node no.
%           level - quad-tree level of children
%
% OUTPUT:   none
%
% SUBROUTINES REQUIRED: GetVertex.m
%                       SearchDist.m
%
% =========================================================================

function AddChildren( n, level );

global Node nNodes Vertex nVertex MaxLevel gmode

n1 = nNodes + 1;
n2 = nNodes + 2;
n3 = nNodes + 3;
n4 = nNodes + 4;

%Point node n toward its new children

Node(n).Children = [n1 n2 n3 n4];

%Create new vertex or find existing vertex for each midpoint

Vx1 = Node(n).Vertex(1);
Vx2 = Node(n).Vertex(2);
Vx3 = Node(n).Vertex(3);

Vx1V = Vertex( Vx1 ).Vector;
Vx2V = Vertex( Vx2 ).Vector;
Vx3V = Vertex( Vx3 ).Vector;

Vx12 = GetVertex( Node(n).Vertex(1), Node(n).Vertex(2) );
Vx23 = GetVertex( Node(n).Vertex(2), Node(n).Vertex(3) );
Vx31 = GetVertex( Node(n).Vertex(3), Node(n).Vertex(1) );

Vx12V = Vertex( Vx12 ).Vector;
Vx23V = Vertex( Vx23 ).Vector;
Vx31V = Vertex( Vx31 ).Vector;

%Child #1

Node(n1).Parent = n;
Node(n1).Children = [];
Node(n1).Vertex = [ Vx1 Vx12 Vx31 ];
Node(n1).Stars = [];
Node(n1).Level = level;

if gmode ~= 0
    PlotNode( n1, 'r' )
end

Node(n1).SDist = SearchDist( Vx1V, Vx12V, Vx31V );

%Child #2

Node(n2).Parent = n;
Node(n2).Children = [];
Node(n2).Vertex = [ Vx2 Vx23 Vx12 ];
Node(n2).Stars = [];
Node(n2).Level = level;

if gmode ~= 0
    PlotNode( n2, 'r' )
end

Node(n2).SDist = SearchDist( Vx2V, Vx23V, Vx12V );

%Child #3

Node(n3).Parent = n;
Node(n3).Children = [];
Node(n3).Vertex = [ Vx3 Vx31 Vx23 ];
Node(n3).Stars = [];
Node(n3).Level = level;

if gmode ~= 0
    PlotNode( n3, 'r' )
end

Node(n3).SDist = SearchDist( Vx3V, Vx31V, Vx23V );

%Child #4

Node(n4).Parent = n;
Node(n4).Children = [];
Node(n4).Vertex = [ Vx12 Vx23 Vx31 ];
Node(n4).Stars = [];
Node(n4).Level = level;

if gmode ~= 0
    PlotNode( n4, 'r' )
end

Node(n4).SDist = SearchDist( Vx12V, Vx23V, Vx31V );

% Add nodes to verticies so all nodes connected to a vertex can be found.
% Only add if at desired depth

if level == MaxLevel
    
    Vertex(Vx1).Nodes = [ Vertex(Vx1).Nodes n1 ];
    Vertex(Vx2).Nodes = [ Vertex(Vx2).Nodes n2 ];
    Vertex(Vx3).Nodes = [ Vertex(Vx3).Nodes n3 ];
    
    Vertex(Vx12).Nodes = [ Vertex(Vx12).Nodes n1 n4 n2 ];
    Vertex(Vx23).Nodes = [ Vertex(Vx23).Nodes n2 n4 n3 ];
    Vertex(Vx31).Nodes = [ Vertex(Vx31).Nodes n3 n4 n1 ];
    
end

% Number of nodes increased by four

nNodes = nNodes + 4;
