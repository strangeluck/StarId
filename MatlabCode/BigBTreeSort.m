% =========================================================================
%
% BigBTreeSort.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Sorts Property.Data by Property.Val and returns sorted pointer array
% using binary trees. "Big" routines best for large amounts of data, since
% memory is preallocated, but requires global variables and so only
% one can be made at a time.
%
% INPUTS:   Prop - structure to be sorted
%             .val - value by which they are to be sorted 
%             .data - data to be sorted
%
% OUTPUT:   Ptr - pointer array of data sorted by val
%
% SUBROUTINES REQUIRED: BigBTreeAdd.m
%                       BigBTreeAscend.m
%
% =========================================================================

function Ptr = BigBTreeSort( Prop );

global TreeVal TreeLeft TreeRight Ptr

% Create binary tree of Prop

'Creating Tree'

n = size( Prop, 2 );
Ptr = zeros( 1, n );

%Tree = [];
for i=1:n
    if i/1000 == floor(i/1000)
        [i n]
    end
    
    BigBTreeAdd( Prop(i), i );
end

'Ascending Tree'

% Create an ordered pointer arry of Prop

root = 1;
i = BigBTreeAscend( root, 0 )  % Output tree in order