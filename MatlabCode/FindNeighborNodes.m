% =========================================================================
%
% FindNeighborNodes.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Creates a list of target-level quad-tree nodes which surround target node.
%
% INPUTS:   tn - target node number
%
% OUTPUT:   NeighborNodes - array of nodes surrounding target node.
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

function NeighborNodes=FindNeighborNodes( tn )

% Search node does not include target node (tn)
% Doesn't check level because when QT is created, only nodes at maximum
% depth are attached to vertexes (Vertex.Nodes)

global Node Vertex MaxLevel

% Construct a list of nodes surrounding inner node

NeighborNodes = [];

for i=1:3                                   % Three verticies per node
    
    vx = Node(tn).Vertex(i);                
    
    for j=1:size( Vertex(vx).Nodes, 2 )

        snnum = Vertex(vx).Nodes(j);        % Get search node number
        
        if snnum ~= tn                      % Don't include target node

            k = find( NeighborNodes == snnum );            
            if size( k,2 ) == 0
                NeighborNodes = [ NeighborNodes snnum ];
            end
           
        end
    end
end
                    
            
        
    
