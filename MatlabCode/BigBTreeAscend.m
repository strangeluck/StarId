% =========================================================================
%
% BigBTreeAscend.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Recursive routine to move through binary tree in order. Stores
% order in pointer array
% "Big" routines best for large amounts of data, since
% memory is preallocated, but requires global variables and so only
% one can be made at a time.
%
% INPUTS:   x - current binary tree location (enter with x = root)
%           i - pointer array location (start i = 0)
%
% OUTPUT:   i - new pointer array location
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

function i = BigBTreeAscend( x, i )

global TreeLeft TreeRight Ptr

if x ~= 0
    i = BigBTreeAscend( TreeLeft(x), i );
    
    i = i + 1;
    Ptr(i) = x;
    
    if i/1000 == floor(i/1000)
        [i]
    end
           
    i = BigBTreeAscend( TreeRight(x), i );
end