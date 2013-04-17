% =========================================================================
%
% Find1NodeAngs.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Finds all angles <= FOVmax within target node
%
% INPUTS:   i - targetNode
%           FOVmax - maximum arc (rads)
%
% OUTPUT:   Ang - structure array of angles <= FOVmax in target node
%             .Stars - star nos. that make up the angle
%             .dotpr - dot product of vectors to stars
%                      (or cosine of angle)
%
% SUBROUTINES REQUIRED: PlotArc.m
%                       WaitForKeyPress.m
%
% =========================================================================

function Ang = Find1NodeAngs( i, FOVmax )

global Node Star gmode

nStars = size( Node(i).Stars, 2 );

nAng = 0;
Ang = [];

if nStars >=2
    
    for j = 1:nStars - 1
        s1 = Node(i).Stars(j);
        s1V = Star(s1).Vector;
        
        for k = j+1:nStars
            s2 = Node(i).Stars(k);
            s2V = Star(s2).Vector;
            
            if gmode ~= 0
                plot3( s1V(1), s1V(2), s1V(3),'og','MarkerSize',2);
                plot3( s2V(1), s2V(2), s2V(3),'or','MarkerSize',2);
            end
            
            dotpr = dot( s1V, s2V );
            
            if acos( dotpr ) <= FOVmax
                nAng = nAng+1;
                Ang(nAng).Stars = [ s1 s2 ];
                Ang(nAng).dotpr = dot( s1V, s2V );                

                if gmode ~= 0                
                    PlotArc( s1V, s2V, 'b' );
                    if gmode == 2
                        WaitForKeyPress;
                    end                    
                end
            end
            
        end

    end
    
end
