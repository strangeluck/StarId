% =========================================================================
%
% BigBTreeAdd.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Adds elements to binary tree.
% "Big" routines best for large amounts of data, since
% memory is preallocated, but requires global variables and so only
% one can be made at a time.
%
% INPUTS:   Val - value to be stored in binary tree
%           n   - location in binary tree array (typically at end + 1)
%
% OUTPUT:   Ptr - pointer array of data sorted by val
%
% SUBROUTINES REQUIRED: BigBTreeAdd.m
%                       BigBTreeAscend.m
%
% =========================================================================

function BigBTreeAdd( Val, n )

global TreeVal TreeLeft TreeRight

% New value placed at current end of array

% n = size( TreeVal, 2 );
% n = n + 1;

TreeVal(n)   = Val;
TreeLeft(n)  = 0;       % Indicate end of left branch
TreeRight(n) = 0;      % Indicate end of right branch

if n == 1                  % If it's the first item in the tree, its the root
    done = 1;
else
    done = 0;
end

% Move through tree until proper position for value is found

i = 1;      % Start at root of tree (first item in tree array)

while done == 0         % repeat until Tri(j) positioned in tree        
    if Val < TreeVal(i)        % if value < current leaf in tree, move left
        if TreeLeft(i) == 0;
            TreeLeft(i) = n;
            done = 1;
        else
            i = TreeLeft(i);
        end
        
    elseif Val >= TreeVal(i)    % if value >= current leaf in tree, move right
        if TreeRight(i) == 0;
            TreeRight(i) = n;
            done = 1;
        else
            i = TreeRight(i);
        end
    end
end