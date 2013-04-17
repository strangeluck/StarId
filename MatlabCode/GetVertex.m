% =========================================================================
%
% GetVertex.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Find if the mid-point vertex desired already exists. If so, it returns
% the vertex number. If the vertex doesn't exist, it is created and added
% to the list of verticies and the number of that vertex is returned.
%
% INPUTS:   Vx1 - Vertex no. 1
%           Vx2 - Vertex no. 2
%
% OUTPUT:   x = vertex no at midpoint of Vertex no 1 and 2
%
% SUBROUTINES REQUIRED: ArcMidPt.m
%
% =========================================================================

function x=GetVertex( Vx1, Vx2 );

global Vertex nVertex gmode

% Check to see if the asked-for vertex already exists.

i = find( Vertex(Vx1).Neighbor == Vx2 );

if size( i,2 ) ~= 0
    
    x = Vertex(Vx1).Child( i );
    
    if gmode ~= 0 
        plot3( Vertex(x).Vector(1), Vertex(x).Vector(2), ...
            Vertex(x).Vector(3),'ob','MarkerSize',7);
    end

else

    nVertex = nVertex + 1;

    Vertex(nVertex).Vector = ArcMidPt( Vertex(Vx1).Vector, ...
        Vertex(Vx2).Vector );
    Vertex(nVertex).Neighbor = [];
    Vertex(nVertex).Nodes = [];

    Vertex(Vx1).Neighbor = [ Vertex(Vx1).Neighbor Vx2 ];
    Vertex(Vx1).Child = [ Vertex(Vx1).Child nVertex ];

    Vertex(Vx2).Neighbor = [ Vertex(Vx2).Neighbor Vx1 ];
    Vertex(Vx2).Child = [ Vertex(Vx2).Child nVertex ];
   
    x = nVertex;
    
    if gmode ~= 0
        plot3( Vertex(x).Vector(1), Vertex(x).Vector(2), ...
            Vertex(x).Vector(3),'ob','MarkerSize',7);
    end
end