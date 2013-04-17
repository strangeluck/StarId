% =========================================================================
%
% SortSphTris.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 12 January 2004
%
% Creates Pointer Array and K-Vector for Unosrted Catalog of Sph Tris
% for Spherical Triangle Method Use
%
% INPUTS:   SphTri2xxxx - Unsorted Catalog Of Spherical Triangles
%
% OUTPUT:   SphTriPtrxxxx - Pointer Array of Sph. Tris, sorted by area
%
% SUBROUTINES REQUIRED: BigBTreeSort.m
%                       CreateParabKvector.m
%
% =========================================================================

clear all;

load SphTri2M60L4

global TreeVal TreeLeft TreeRight

Tri = Tri(1:nTri);

% Preallocate memory for everything

'Tree Allocation'
TreeVal   = zeros( 1, nTri );
TreeLeft  = zeros( 1, nTri );
TreeRight = zeros( 1, nTri );

'TriPtr Allocation'
TriPtr    = zeros( 1, nTri );

'Kvec Allocation'
SphArea   = zeros( 1, nTri );
Kvec.Ptr  = zeros( 1, nTri );

% Index Stars by Spherical Area

'Sort'

TriPtr = BigBTreeSort( [ Tri.Area ] );

% Create Parabolic Kvector of Stars

'K-Vector'

for i=1:nTri
    if i/1000 == floor(i/1000)
        [i nTri]
    end
    
    SphArea(i) = Tri( TriPtr(i) ).Area;
end

Kvec = CreateParabKvector( SphArea )

save SphTriPtrM60L4 TriPtr Kvec