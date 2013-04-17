% =========================================================================
%
% CreateStarQuadTree.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Creates a quad-tree of stars so that angle and spherical triangle
% catalogs can be created efficiently. Maximum search distance
% also calculated.
%
% INPUTS:   Star List (Stars.mat)
%
% OUTPUT:   Quad-Tree (QTxxx.mat)
%
% SUBROUTINES REQUIRED: PlotNode.m
%                       GetNodeNum.m
%                       WaitForKeyPress.m
%
% =========================================================================

clear all;

global MaxLevel gmode

MagLimit = 6;
MaxLevel = 4;

gmode = 2;  %1 = graphics yes, 0 = no graphics, 2= wait

%Calculate max number of nodes (Always less verticies)

maxnodes = 0;
for i=1:MaxLevel
    maxnodes = maxnodes + 4^i;
end
maxnodes = maxnodes

load Stars

tic

% Initialize plot if graphics are desired

if gmode ~= 0
  hold off;
  plot3( 0,0,0 ,'om','MarkerSize',2);
  hold on;
  axis( [-1 1 -1 1 -1 1] );
  grid on;
end

InitVertices;
InitNodes;

%  Put stars into quad-tree

for i=1:nStars
    [i nStars]
    
    if gmode == 2
        hold off;
        PlotNode(1,'r');
        hold on;
        PlotNode(2,'r');
        PlotNode(3,'r');
        PlotNode(4,'r');
        plot3( 0,0,0 ,'oy','MarkerSize',2);
        axis( [-1 1 -1 1 -1 1] );
        grid on;
    end
    
    if Star(i).Mag < MagLimit
        
        if gmode ~= 0
            plot3( Star(i).Vector(1), Star(i).Vector(2), ...
                   Star(i).Vector(3),'og','MarkerSize',2);
        end
         
        % Find node in which star should reside, then add star to it
        
        nnum = GetNodeNum( Star(i).Vector );    
        Node(nnum).Stars = [ Node(nnum).Stars i ];
        
    else        
        break
    end    

% Good for demo -- wait for keypress between stars    

    if gmode == 2
        WaitForKeyPress; 
    end
end

toc

% Just a check... should add up to the correct number of stars

nStars = 0;
for i=1:nNodes
    nStars = nStars + size( Node(i).Stars, 2 );
end
nStars

% Find distance that can be searched with this level quad-tree

SearchLimit = 2*pi;
for i=1:nNodes
    if Node(i).SDist < SearchLimit
        SearchLimit = Node(i).SDist;
    end
end
SearchLimit*180/pi

save QTM60L4 Node nNodes Vertex nVertex MagLimit MaxLevel SearchLimit