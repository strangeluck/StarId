% =========================================================================
%
% Find1NodeSphTris.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Finds all spherical triangles that occupy a FOV less than FOVmax within
% target node.
%
% INPUTS:   i - target node no.
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

function Tri = Find1NodeSphTris( i, FOVmax )

global Node Star gmode

nStars = size( Node(i).Stars, 2 );

nTri = 0;
Tri = [];

if gmode == 2
    for j=1:nStars
        s1  = Node(i).Stars(j);
        s1V = Star(s1).Vector;
        
        plot3( s1V(1), s1V(2), s1V(3),'or','MarkerSize',2);
    end
end

if nStars >=3
    
    for j = 1:nStars - 2
        s1  = Node(i).Stars(j);
        s1V = Star(s1).Vector;
        
        for k = j+1:nStars - 1
            s2  = Node(i).Stars(k);
            s2V = Star(s2).Vector;
            
            if acos( dot(s1V,s2V) ) < FOVmax
                
                for l = k+1:nStars
                    s3  = Node(i).Stars(l);
                    s3V = Star(s3).Vector;
                    
                    if acos( dot(s1V,s3V) ) < FOVmax
                        if acos( dot( s2V, s3V) ) < FOVmax
                            
                            FOV = CalcFOV( s1V, s2V, s3V );
                            
                            if FOV <= FOVmax
                                nTri = nTri+1;
                                Tri(nTri).Stars = sort( [ s1 s2 s3 ] );
                                Tri(nTri).FOV = FOV;
                                
                                if gmode == 2
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
    
end
