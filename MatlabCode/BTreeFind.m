% =========================================================================
%
% BTreeFind.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Locates value in binary tree. If more than one exist, an array is output
% of all locations.
%
% INPUTS:   Val - value to be found
%           Tree - Binary Tree to search
%
% OUTPUT:   Ptr - array of locations where value was found
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

function Ptr = BTreeFind( Val, Tree )

% Find location of Value in binary tree
% Tree Structure:   Tree.Val   - Item to be stored
%                   Tree.left  - pointer to left branch
%                   Tree.right - pointer to right branch

% Move throught tree until value is found or search is exhausted

i = 1;      % Start at root of tree (first item in tree array)

Ptr = [];
done = 0;
while done == 0 
    
    if Val == Tree(i).Val
        Ptr = [ Ptr i ];
    end
    
    if Val < Tree(i).Val        % if value < current leaf in tree, move left
        if Tree(i).left == 0;
            done = 1;
        else
            i = Tree(i).left;
        end
    elseif Val >= Tree(i).Val    % if value >= current leaf in tree, move right
        if Tree(i).right == 0;
            done = 1;
        else
            i = Tree(i).right;
        end
    end
end