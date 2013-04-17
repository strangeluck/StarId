% =========================================================================
%
% CatalogAngles.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Creates catalog of angles suitable for Angle Recognition Algorithm
%
% INPUTS -  Star data (Stars.mat)
%           Output of CreateQuadTree.m (QTxxxx.mat)
%
% OUTPUT -  Angle Catalog (Ang****.mat)
%
% SUBROUTINES REQUIRED: FindNeighborNodes.m
%                       PlotNode.m
%                       Find1NodeAngs.m
%                       Fing2NodeAngs.m
%                       WaitForKeyPress.m
%
% =========================================================================

clear all;

global Star Node FOVmax gmode

% Set graphics mode: gmode = 0   No graphics. Fastest results
%                            1   Stop after each node
%                            2   Stop after each angle

gmode = 1;

load QTM60L4
load Stars

FOVmax = SearchLimit;
FOVmax * 180/pi

nAng = 0;
Ang = [];

% Set up nodes to record when combos with two nodes are made

for i=1:nNodes
    Node(i).Doubles = [];
end

tic

% Go through all the nodes

for i=1:nNodes
    if Node(i).Level == MaxLevel
     
% Find all nodes surrounding center node
        
        NeighborNodes = FindNeighborNodes( i );     % Get array of surrounding nodes
        nNeighborNodes = size( NeighborNodes, 2 );
    
        if gmode ~= 0
            hold off;
            PlotNode( i, 'g' );
            hold on;    
            grid on;
            
            for j=1:nNeighborNodes
                PlotNode( NeighborNodes(j),'b' );
            end
        end
        
% Find all suitable triangles within target node

        Ang = [Ang Find1NodeAngs( i, FOVmax )];
        
% Find all suitable triangles between target and any other surrounding node

        if nNeighborNodes >= 1
            
            for m = 1:nNeighborNodes
                j = NeighborNodes(m);
            
                % First check that these two nodes haven't been checked before

                k = find( Node(i).Doubles == j );
                        
                if size( k,2 ) == 0                  
                    Ang = [Ang Find2NodeAngs( i, j, FOVmax )];

                    % Record nodes so they're not counted again                    
                    
                    Node(i).Doubles = [ Node(i).Doubles j ];
                    Node(j).Doubles = [ Node(j).Doubles i ];
                end
            end
        end
        
        if gmode ~= 0
            WaitForKeyPress;
        end
        
        [i nNodes size( Ang,2 )]
        toc   

    else   
        [i nNodes size( Ang,2 )]
        toc    
        
    end
    
end

nAng = size( Ang, 2 )

save AngM60L4 Ang nAng FOVmax