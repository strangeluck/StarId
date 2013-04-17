% =========================================================================
%
% GetNodeNum.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Given a unit vector, this routine will determine what node number is lies
% within. If the node does not exist it will create nodes as necessary.
%
% INPUTS:   Vector - vector for which node will be found
%
% OUTPUT:   nnum - node number which vector should be placed
%
% SUBROUTINES REQUIRED: AddChildren.m
%                       WhichNode.m
%                       PlotNode.m
%
% =========================================================================

function nnum = GetNodeNum( Vector )

global Node Star MaxLevel gmode

% Drill through quad-tree to target level

for level=1:MaxLevel            
    
    % Find children of current node (start with first fourn nodes in tree)
    
    switch level
        case 1                      % Start with first four nodes in Node list
            nodeptr = [1 2 3 4];
        otherwise                   % Otherwise use children of current node            
            if size( Node(nnum).Children, 2 ) == 0      %If no children, add them
                AddChildren( nnum, level );
            end
            nodeptr = Node(nnum).Children;
    end
    
    % Determine which of the four nodes vector should be placed
    
    nnum = WhichNode( Vector, nodeptr );
    
    if gmode ~= 0
        if level == MaxLevel
            PlotNode( nnum, 'r' );
        end
    end
    
end
