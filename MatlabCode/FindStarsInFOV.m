% =========================================================================
%
% FindStarsInFOV.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Given a vector and field of view, this routine will output an array of
% all the stars in the field of view.
%
% INPUTS:   trvector - star tracker camera vector
%           FOV - field of view of camera
%           QTxxxx - quad-tree of stars (need fresh version loaded ea time)
%
% OUTPUT:   StarList - array of stars
%
% SUBROUTINES REQUIRED: GetNodeNum.m
%                       PlotNode.m
%                       FindNeighborNodes.m
%
% =========================================================================

function StarList = FindStarsInFOV( trvector, FOV )

global Star gmode Vertex nVertex

% Get node number in which vector points (nodes created as necessary)

load QTM60L4;   % Use unaltered version every time

nnum = GetNodeNum ( trvector );

if bitand( gmode, 1 ) == 1
    PlotNode( nnum, 'c' );
end

% Add stars in node to list if it is within FOV of tracker

nStars = 0;
StarList.Star = [];

for k = 1:size( Node(nnum).Stars, 2 )
    starnum = Node(nnum).Stars(k);
    
    theta = acos( dot( Star(starnum).Vector, trvector )/1 );
    
    if theta <= FOV/2
        nStars = nStars + 1;
        StarList(nStars).Star = starnum;
        if bitand( gmode, 1 ) == 1
            plot3( Star(starnum).Vector(1), Star(starnum).Vector(2), ...
                Star(starnum).Vector(3),'og','MarkerSize',2);
        end    
    elseif bitand( gmode, 1) == 1
        plot3( Star(starnum).Vector(1), Star(starnum).Vector(2), ...
            Star(starnum).Vector(3),'or','MarkerSize',2);
    end
end

% Go through neighbor nodes and and stars to list if they are with FOV of tracker

NeighborNodes = FindNeighborNodes( nnum );     % Get array of surrounding nodes
nNeighborNodes = size( NeighborNodes, 2 );

for j = 1:nNeighborNodes
    
    if bitand( gmode, 1 ) == 1
        PlotNode( NeighborNodes(j), 'm' );
    end
    
    for k = 1:size( Node( NeighborNodes(j) ).Stars, 2 )
        starnum = Node( NeighborNodes(j) ).Stars(k);
        
        theta = acos( dot( Star(starnum).Vector, trvector )/1 );
        %             theta*180/pi
        
        if theta <= FOV/2
            nStars = nStars + 1;
            StarList(nStars).Star = starnum;
            if bitand( gmode, 1 ) == 1
                plot3( Star(starnum).Vector(1), Star(starnum).Vector(2), ...
                    Star(starnum).Vector(3),'og','MarkerSize',2);
            end        
        elseif bitand( gmode, 1 ) == 1
            plot3( Star(starnum).Vector(1), Star(starnum).Vector(2), ...
                Star(starnum).Vector(3),'or','MarkerSize',2); 
        end
    end
end
    
