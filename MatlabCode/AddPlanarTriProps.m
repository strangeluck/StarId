% =========================================================================
%
% AddPlanarTriProps
%
% THESIS: FAST STAR PATTERN RECOGNITION USING TRIANGLES
% Craig L Cole
% 12 January 2004
%
% DESCRIP
%
% INPUTS:   SphTrixxxx - Catalog of Triangles (SphTri catalog is fine for
%                        planar Tri Calcs)
%           Stars - List of stars
%
% OUTPUT:   PlanarTri2xxxx - Catalog of Triangle with Area and Ip
%
% SUBROUTINES REQUIRED: SphTriArea.m
%                       SphTriPolarMoment.m
%
% =========================================================================

%Calculate properties of triangles

load SphTriM60L4;
load Stars;

for i=1:nTri
    if i/100 == floor(i/100)
        [ i nTri ]
    end
    
    v1 = Star( Tri(i).Stars(1) ).Vector;
    v2 = Star( Tri(i).Stars(2) ).Vector;
    v3 = Star( Tri(i).Stars(3) ).Vector;
      
    Tri(i).Area = PlanarTriArea( v1, v2, v3 );
    Tri(i).Ip   = PlanarTriPolarMoment( v1, v2, v3 );
end

save PlanarTri2M60L4 Tri nTri FOVmax