% =========================================================================
%
% AddSphTriProps
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% DESCRIP
%
% INPUTS:   SphTrixxxx - Catalog of Triangles
%           Stars - List of stars
%
% OUTPUT:   SphTri2xxxx - Catalog of Triangle with Area and Ip
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
      
    Tri(i).Area = SphTriArea( v1, v2, v3 );
    Tri(i).Ip   = SphTriPolarMoment( v1, v2, v3, 3, 0, 0 );
end

save SphTri2M60L4 Tri nTri FOVmax