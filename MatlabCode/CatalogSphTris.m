% =========================================================================
%
% CatalogSphTris.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Creates a catalog of spherical triangles suitable for spherical triangle
% method.
%
% INPUTS:   Quad-Tree of Stars (QTxxxx.mat)
%           Stars (Stars.mat)
%
% OUTPUT:   Spherical Triangle Catalog (SphTrixxxx.mat)
%
% SUBROUTINES REQUIRED: FindNeighborNodes.m
%                       PlotNode.m
%                       Find1NodeSphTris.m
%                       Find2NodeSphTris.m
%                       Find3NodeSphTris.m
%                       WaitForKeyPress.m
%
% =========================================================================

clear all

global Star Node gmode  % FOVmax fast gmode

% Set graphics mode: gmode = 0   No graphics. Fastest results
%                            1   Summary
%                            2   Stop after each pair

gmode = 2;

load QTM60L4
load Stars

FOVmax = SearchLimit;
FOVmax * 180/pi

nTri = 0;
Tri = [];

% Set up nodes to record when combos with two and three nodes are made

for i=1:nNodes
    Node(i).Doubles = [];
    Node(i).Triples = [];
end

% Initialize plot if graphics are desired

if gmode ~= 0
    hold off;
    plot3( 0,0,0 ,'oy','MarkerSize',2);
    hold on;
%     axis( [-1 1 -1 1 -1 1] );
    grid on;
end

tic

% Go through all the nodes

for i=1:nNodes
    if Node(i).Level == MaxLevel
     
% Find all nodes surrounding center node
        
        NeighborNodes = FindNeighborNodes( i );     % Get array of surrounding nodes
        nNeighborNodes = size( NeighborNodes, 2 );
    
        switch( gmode )
            case 1
                PlotNode( i, 'r' );
            case 2
                PlotNode( i, 'g' );
                
                for j=1:nNeighborNodes
                    PlotNode( NeighborNodes(j),'b' );
                end
        end
        
% Find all suitable triangles within target node

        newTri = Find1NodeSphTris( i, FOVmax );
        Tri = [Tri newTri];
        
% Find all suitable triangles between target and any other surrounding node

        if nNeighborNodes >= 1
            
            for m = 1:nNeighborNodes
                j = NeighborNodes(m);
            
                % First check that these two nodes haven't been checked before

                k = find( Node(i).Doubles == j );
                        
                if size( k,2 ) == 0                  
                    newTri = Find2NodeSphTris( i, j, FOVmax );
                    Tri = [ Tri newTri ];
                    
                    % Record nodes so they're not counted again                    
                    
                    Node(i).Doubles = [ Node(i).Doubles j ];
                    Node(j).Doubles = [ Node(j).Doubles i ];
                end
            end
        end
    
    % Find all suitable triangles between target and any two search nodes

        if nNeighborNodes >=3
    
            for m = 1:nNeighborNodes - 1
                j = NeighborNodes(m);
            
                for n = m+1:nNeighborNodes
                    k = NeighborNodes(n);
               
                % First check that these three nodes haven't been checked before

                    done = 0;           
                    for x = 1:size( Node(i).Triples, 1 );
                        if Node(i).Triples(x,:) == [ j k ]
                            done = 1;
                            break;
                        elseif Node(i).Triples(x,:) == [ k j ]
                            done = 1;
                            break;
                        end
                    end
    
            % If not, count all triangles with a point in each node
            
                    if done == 0
                        
                        newTri = Find3NodeSphTris( i, j, k, FOVmax );
                        Tri = [Tri newTri];
                        
                        % Record nodes so they're not counted again
                        
                        Node(i).Triples = [ Node(i).Triples; j k ];
                        Node(j).Triples = [ Node(j).Triples; i k ];
                        Node(k).Triples = [ Node(k).Triples; i j ];
                    end
      
                end
            end
        end
        
      if gmode == 1
          WaitForKeyPress;
      end
  end
    
    nTri = size( Tri, 2 );
    [i nNodes nTri]
    toc
end            

save SphTriM60L4 Tri nTri FOVmax