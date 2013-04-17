% =========================================================================
%
% Find2NodeSphTris.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Finds all spherical triangles that occupy a FOV less than FOVmax.
% Spherical triangles have one vertex in node i, two in node j, or
% vice-versa.
%
% INPUTS:   i - first node no.
%           j - second node no.
%           FOVmax - FOV limit for spherical triangle
%
% OUTPUT:   Tri - structure array of angles <= FOVmax in target node
%             .Stars - star nos. that make up the angle
%             .dotpr - dot product of vectors to stars
%                      (or cosine of angle)
%
% SUBROUTINES REQUIRED: PlotArc.m
%                       WaitForKeyPress.m
%
% =========================================================================

function Tri = Find2NodeSphTris( i, j, FOVmax )

global Node Star gmode  

nStarsi = size( Node(i).Stars, 2 );
nStarsj = size( Node(j).Stars, 2 );

nTri = 0;
Tri = [];

if gmode == 2
    for k=1:nStarsi
        s1  = Node(i).Stars(k);
        s1V = Star(s1).Vector;        
        plot3( s1V(1), s1V(2), s1V(3),'or','MarkerSize',2);
    end
    for k=1:nStarsj
        s1  = Node(j).Stars(k);
        s1V = Star(s1).Vector;        
        plot3( s1V(1), s1V(2), s1V(3),'or','MarkerSize',2);
    end
end

if nStarsi >= 2
    
    % Two stars from target node, one star from surrounding node 

    for x = 1:nStarsi - 1
        s1  = Node(i).Stars(x);
        s1V = Star(s1).Vector;
        
        for y = x+1:nStarsi
            s2 = Node(i).Stars(y);
            s2V = Star(s2).Vector;
            
            if acos( dot( s1V, s2V ) ) < FOVmax
            
                for z = 1:nStarsj
                    s3 = Node(j).Stars(z);
                    s3V = Star(s3).Vector;
                    
                    if acos( dot( s1V, s3V )) < FOVmax
                        if acos( dot( s2V, s3V )) < FOVmax
     
                            FOV = CalcFOV( s1V, s2V, s3V );
                
                            if FOV <= FOVmax
                                nTri = nTri + 1;
                                Tri(nTri).Stars = sort( [ s1 s2 s3 ] );
                                Tri(nTri).FOV = FOV;
                    
                                if gmode ~= 0
                                    PlotSphericalTri( s1V, s2V, s3V, 'm' );
                                end
                            end
                            
                        end
                    end
                    
                end

            end                                
        end
    end
    
end

% Repeat with 1 star from target node, two stars from surrounding node 

nStars = size( Node(j).Stars, 2 );

if nStars >= 2
    
    for x = 1:size( Node(i).Stars, 2 )
    s1 = Node(i).Stars(x);
    s1V = Star(s1).Vector;
        
        for y = 1:size( Node(j).Stars, 2 ) - 1
            s2 = Node(j).Stars(y);
            s2V = Star(s2).Vector;
            
            if acos( dot( s1V, s2V ) ) < FOVmax
            
                for z = y+1:size( Node(j).Stars, 2 )
                    s3 = Node(j).Stars(z);
                    s3V = Star(s3).Vector;
                    
                    if acos( dot( s1V, s3V ) ) < FOVmax
                        if acos( dot( s2V, s3V ) ) < FOVmax
                
                            FOV = CalcFOV( s1V, s2V, s3V );
                
                            if FOV <= FOVmax
                                nTri = nTri + 1;
                                Tri(nTri).Stars = sort( [ s1 s2 s3 ] );
                                Tri(nTri).FOV = FOV;
                    
                                if gmode ~= 0
                                    PlotSphericalTri( s1V, s2V, s3V, 'm' );
                                end
                            end
                            
                        end
                    end
                    
                end
    
            end
        end
    end
    
end
