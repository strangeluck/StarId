% =========================================================================
%
% FindStDev.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Plots standard deviation of a 1,000 random triangles measured 100 times.
%
% INPUTS:   SphTri2xxxx - catalog of spherical triangles with area and Ic
%
% OUTPUT:   none
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

clear all;

load Stars;
load SphTri2M60L4

sigm = (87.2665e-6)/3;  % Sigma bound for error (normal distribution)

for i=1:1000
    
    j = round( nTri*rand(1) );
    
    [i j]
    
    sv1.t = Star( Tri(j).Stars(1) ).Vector;
    sv2.t = Star( Tri(j).Stars(2) ).Vector;
    sv3.t = Star( Tri(j).Stars(3) ).Vector;

    Area(i) = SphericalTriArea( sv1.t, sv2.t, sv3.t );
    Ic(i)   = SphTriSecondMoment( sv1.t, sv2.t, sv3.t, 3, 0, 0 );
    
    for k = 1:100
        sv1.m = AddNoise( sv1.t, sigm );
        sv2.m = AddNoise( sv2.t, sigm );    
        sv3.m = AddNoise( sv3.t, sigm );

        AreaM(k) = SphericalTriArea( sv1.m, sv2.m, sv3.m );
        IcM(k)   = SphTriSecondMoment( sv1.m, sv2.m, sv3.m, 4, 0, 0 );
    end    
    StdevA(i) = std( AreaM );
    StdevI(i) = std( IcM );
end

% Find best fitting line

figure(1);
plot( Area, StdevA, 'or' );
title('Standard Deviation of Area Measurement vs. Triangle Area ');
xlabel('Triangle True Area');
ylabel('Measurement Standard Deviation');

figure(2);
plot( Ic, StdevI, 'or' );
title('Standard Deviation of Ic Measurement vs. Triangle Area ');
xlabel('Triangle True Second Moment');
ylabel('Measurement Standard Deviation');