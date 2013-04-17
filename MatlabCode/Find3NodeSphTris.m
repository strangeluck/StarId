% =========================================================================
%
% Find3NodeSphTris.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Finds all spherical triangles that occupy a FOV less than FOVmax.
% Spherical triangles have one vertex in each of the three nodes.
%
% INPUTS:   i - first node no.
%           j - second node no.
%           k - third node no.
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

function Tri = Find3NodeSphTris( i, j, k, FOVmax )

global Node Star gmode

nTri = 0;
Tri = [];

nStarsi = size( Node(i).Stars, 2 );
nStarsj = size( Node(j).Stars, 2 );
nStarsk = size( Node(k).Stars, 2 );

if gmode == 2
    for n=1:nStarsi
        s1  = Node(i).Stars(n);
        s1V = Star(s1).Vector;        
        plot3( s1V(1), s1V(2), s1V(3),'or','MarkerSize',2);
    end
    for n=1:nStarsj
        s1  = Node(j).Stars(n);
        s1V = Star(s1).Vector;        
        plot3( s1V(1), s1V(2), s1V(3),'or','MarkerSize',2);
    end
    for n=1:nStarsk
        s1  = Node(k).Stars(n);
        s1V = Star(s1).Vector;        
        plot3( s1V(1), s1V(2), s1V(3),'or','MarkerSize',2);
    end
end

for x = 1:size( Node(i).Stars, 2 )
    s1  = Node(i).Stars(x);
    s1V = Star(s1).Vector;
    
    for y = 1:size( Node(j).Stars, 2 )
        s2  = Node(j).Stars(y);
        s2V = Star(s2).Vector;
        
        if acos( dot( s1V, s2V ) ) < FOVmax
        
            for z = 1:size( Node(k).Stars, 2 )
                s3  = Node(k).Stars(z);
                s3V = Star(s3).Vector;
                
                if acos( dot( s1V, s3V ) ) < FOVmax
                    if acos( dot( s2V, s3V ) ) < FOVmax     
            
                        FOV = CalcFOV( s1V, s2V, s3V ); 
            
                        if FOV <= FOVmax
                            nTri = nTri+1;
                            Tri(nTri).Stars = sort( [ s1 s2 s3 ] );
                            Tri(nTri).FOV = FOV;
                
                            if gmode ~= 0
                                PlotSphericalTri( s1V, s2V, s3V, 'm' );
                                WaitForKeyPress;
                            end
                        end
                        
                    end
                    
                end
            end

        end
        
    end
    
end
