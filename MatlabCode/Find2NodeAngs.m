% =========================================================================
%
% Find2NodeAngs.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Makes a list of all angles <=FOVmax which have one star in one node,
% and one in another.
%
% INPUTS:   i - first node no.
%           j - second node no.
%           FOVmax - limit angle (rads)
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

function Ang = Find2NodeAngs( i, j, FOVmax )

global Node Star gmode

nAng = 0;
Ang = [];

for x = 1:size( Node(i).Stars, 2 )
    s1 = Node(i).Stars(x);
    s1V = Star(s1).Vector;
    
    for y = 1:size( Node(j).Stars, 2 )
        s2 = Node(j).Stars(y);
        s2V = Star(s2).Vector;
        
        if gmode ~= 0
            plot3( s1V(1), s1V(2), s1V(3),'og','MarkerSize',2);
            plot3( s2V(1), s2V(2), s2V(3),'or','MarkerSize',2);
        end
        
        dotpr = dot( s1V, s2V );
        
        if acos( dotpr ) <= FOVmax
            nAng = nAng+1;
            Ang(nAng).Stars = [ s1 s2 ];
            Ang(nAng).dotpr = dotpr;            

            if gmode ~= 0
                PlotArc( s1V, s2V, 'b' );
                
                if gmode == 2
                    WaitForKeyPress;
                end
            end
        end 
        
    end
end
