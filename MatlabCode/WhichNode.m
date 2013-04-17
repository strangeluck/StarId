% =========================================================================
%
% WhichNode.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Determines which of four nodes vector lies within
%
% INPUTS:   Vt - target vector to be located
%           nodeptr - array of four node nos. to examine
%
% OUTPUT:   n - node no. in which target vector lies within
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

function n=WhichNode( Vt, nodeptr );

global Vertex Node

n = 0;

for i = 1:4
    
    % Get Vertex Numbers that make up the node being pointed to
    
    v1 = Node( nodeptr(i) ).Vertex(1);
    v2 = Node( nodeptr(i) ).Vertex(2);
    v3 = Node( nodeptr(i) ).Vertex(3);
    
    % Calculate cross product between vertex vectors. The results are
    % the values used for the equation of the plane formed by them
 
    n12 = cross( Vertex(v1).Vector, Vertex(v2).Vector );
    n23 = cross( Vertex(v2).Vector, Vertex(v3).Vector );
    n31 = cross( Vertex(v3).Vector, Vertex(v1).Vector );
    
    % Insert values from normals into coefficients for equations of planes

    A = [ n12(1) n23(1) n31(1) ];
    B = [ n12(2) n23(2) n31(2) ];
    C = [ n12(3) n23(3) n31(3) ];
    D = 0;                               % plane passes through (0,0,0)
    
    % x,y,z of Star
    
    x = Vt(1);
    y = Vt(2);
    z = Vt(3);
    
    % If star is within planes formed by vertex vectors, the solution of
    % all three plane equations will be positive.
    
    if A(1)*x + B(1)*y + C(1)*z + D >= 0
        if A(2)*x + B(2)*y + C(2)*z + D >= 0
            if A(3)*x + B(3)*y + C(3)*z + D >= 0
                n = nodeptr(i);
                break
            end
        end
    end
    
end