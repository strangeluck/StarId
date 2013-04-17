% =========================================================================
%
% BTreeAdd.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Adds element to binary tree in order of val.
%
% INPUTS:   Val - value to determine sort
%           Data - data to be stored with it
%           Tree - Binary Tree to search
%
% OUTPUT:   Tree - updated binary tree
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

function Tree = BTreeAdd( Val, Data, Tree )

% New value placed at current end of array

n = size( Tree, 2 );
n = n + 1;

Tree(n).Val   = Val;
Tree(n).Data  = Data;
Tree(n).left  = 0;       % Indicate end of left branch
Tree(n).right = 0;      % Indicate end of right branch

if n == 1                  % If it's the first item in the tree, its the root
    done = 1;
else
    done = 0;
end

% Move through tree until proper position for value is found

i = 1;      % Start at root of tree (first item in tree array)

while done == 0         % repeat until Tri(j) positioned in tree        
    if Val < Tree(i).Val        % if value < current leaf in tree, move left
        if Tree(i).left == 0;
            Tree(i).left = n;
            done = 1;
        else
            i = Tree(i).left;
        end
        
    elseif Val >= Tree(i).Val    % if value >= current leaf in tree, move right
        if Tree(i).right == 0;
            Tree(i).right = n;
            done = 1;
        else
            i = Tree(i).right;
        end
    end
end