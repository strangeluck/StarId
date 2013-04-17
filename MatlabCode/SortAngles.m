% =========================================================================
%
% SortAngles.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Creates Pointer Array and K-Vector for Unosrted Catalog of Angles
% for Angle Method Use
%
% INPUTS:   Angxxxx - Unsorted Catalog Of Angles
%
% OUTPUT:   AngPtrxxxx - Pointer Array of Angles, sorted by angle
%
% SUBROUTINES REQUIRED: BigBTreeSort.m
%                       CreateLinKvector.m
%
% =========================================================================

clear all;

load AngM60L4A

global TreeVal TreeLeft TreeRight

nAng = 10000
Ang = Ang(1:nAng);

% Preallocate memory for everything

'Tree Allocation'
TreeVal   = zeros( 1, nAng );
TreeLeft  = zeros( 1, nAng );
TreeRight = zeros( 1, nAng );

'TriPtr Allocation'
AngPtr    = zeros( 1, nAng );

'Kvec Allocation'
DotPrs    = zeros( 1, nAng );
Kvec.Ptr  = zeros( 1, nAng );

% Index Stars by Spherical Area

'Sort'

AngPtr = BigBTreeSort( [ Ang.dotpr ] );

% Create linear Kvector of Angles

'K-Vector'

for i=1:nAng
    if i/1000 == floor(i/1000)
        [i nAng]
    end
    
    DotPrs(i) = Ang( AngPtr(i) ).dotpr;
end

Kvec = CreateLinKvector( DotPrs )

save AngPtrM60L4 AngPtr Kvec