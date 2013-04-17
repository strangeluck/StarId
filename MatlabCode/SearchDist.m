% =========================================================================
%
% SearchDist.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Determines minimum height (arc) of a spherical triangle
% Works if height is less or equal to 90 degrees.
% If height is greater subtract results from pi
%
% INPUTS:   v1 - vector no. 1 to vertex of spherical triangle
%           v2 - vector no. 2 to vertex of spherical triangle
%           v3 - vector no. 3 to vertex of spherical triangle
%
% OUTPUT:   d - minimum height of triangle (rads)
%
% SUBROUTINES REQUIRED: PlotArc.m
%
% =========================================================================

function d = SearchDist( v1, v2, v3 )

global gmode

a = acos( dot(v1,v2) );
b = acos( dot(v2,v3) );
c = acos( dot(v3,v1) );

% Determine longest side (shortest search distance)

if a > b
    if a > c
        % long side is a
        r1 = v1;
        r2 = v2;
        r3 = v3;
    else
        % long side is c
        r1 = v3;
        r2 = v1;
        r3 = v2;
    end
else
    if b > c
        % long side is b  
        r1 = v2;
        r2 = v3;
        r3 = v1;
    else
        % long side is c       
        r1 = v3;
        r2 = v1;
        r3 = v2;        
    end
end

% Find normal to plane formed by vectors to long side

n1 = cross(r1,r2);
n1 = n1 / norm(n1);

% Find norm to plane perp to plane formed by vectors
% to long side and passes through r3.  

n2 = cross(n1,r3);

if norm(n2) ~= 0
    
    % If cross product is not zero plane exists
    
    n2 = n2 / norm(n2);

    % Find vector formed where plane formed by vectors to 
    % long side intersects perp plane    
    
    r4 = cross( n2, n1 );
    r4 = r4 / norm( r4 );
    
else
    
    % If cross product is zero, r3 is rt angle to both
    % r1 and r2. r4 can be any pt along arc between r1
    % and r2. Mid pt chosen so arc r3 to r4 is easy to see.
    
    r4 = ArcMidPt( r1, r2 );
    
end

% plot3( [0 r4(1)], [0 r4(2)], [0 r4(3)], 'b' );

if gmode == 2
    PlotArc( r3, r4, 'b' );
end

% Distance is equal to arc between r3 and r4

d = acos( dot( r4, r3 ) );