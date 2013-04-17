% =========================================================================
%
% SortPlanarTris.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING TRIANGLES
% Craig L Cole
% 12 January 2004
%
% Creates Pointer Array and K-Vector for Unosrted Catalog of Planar
% Triangles for Planar Angle Method Use
%
% INPUTS:   PlanarTri2xxxx - Unsorted Catalog Of Planar Triangles
%
% OUTPUT:   PlanarTriPtrxxxx - Pointer Array of Planar Tris, sorted by area
%
% SUBROUTINES REQUIRED: BigBTreeSort.m
%                       CreateParabKvector.m
%
% =========================================================================

clear all;

load PlanarTri2M60L4

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
PlanarArea   = zeros( 1, nTri );
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
    
    PlanarArea(i) = Tri( TriPtr(i) ).Area;
end

Kvec = CreateParabKvector( PlanarArea )

save PlanarTriPtrM60L4 TriPtr Kvec