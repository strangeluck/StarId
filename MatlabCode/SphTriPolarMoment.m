% =========================================================================
%
% SphTriPolarMoment.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Calculates the polar moment of a spherical triangle unit
%
% INPUTS:   v1 - unit vector to vertex 1
%           v2 - unit vector to vertex 2
%           v3 - unit vector to vertex 3
%           MaxLevel - level of recursion (recommend 3 minimum)
%           gc - global centroid (ignored on entry)
%           level - current level of recursion (set to 0 when calling)
%
% OUTPUT:   Ip - Polar Moment of Spherical Triangle
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

function Ip = SphTriPolarMoment( v1, v2, v3, MaxLevel, gc, level )

gmode = 0;

% Find global centroid at first pass

if level == 0
    gc = SphTriCentroid( v1, v2, v3 );    
    if gmode ~= 0
        hold off;
        figure(10);
    end
end

if gmode ~= 0
    PlotSphericalTri( v1, v2, v3, 'r' );
end

if level < MaxLevel
    
    % Find mid point of edges of triangle
    
    m12 = ArcMidPt( v1, v2 );
    m23 = ArcMidPt( v2, v3 );
    m31 = ArcMidPt( v3, v1 );
    
    % Further divide triangle
    
    Ip = SphTriPolarMoment( v1, m12, m31, MaxLevel, gc, level+1 );
    Ip = Ip + SphTriPolarMoment( v2, m12, m23, MaxLevel, gc, level+1 );
    Ip = Ip + SphTriPolarMoment( v3, m23, m31, MaxLevel, gc, level+1 );
    Ip = Ip + SphTriPolarMoment( m12, m23, m31, MaxLevel, gc, level+1 );
    
else
    
    % Calculate polar moment about global centroid
    
    lc = SphTriCentroid( v1, v2, v3 );  % local centroid
    if gmode ~= 0
        PlotArc( lc, gc, 'g' );
    end
    
    dA = SphTriArea( v1, v2, v3 );      % area of element
    theta = acos( dot( lc, gc ) );            % arc distance to centroid
    Ip = theta^2 * dA;
    
end