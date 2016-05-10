% =========================================================================
%
% MatchStarsWAngs.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Takes a list of stars in FOV, and tries to match up stars in catalog
% using angle method.
%
% INPUTS:   StarsInFOV - Array of stars in field of view & measured vectors
%           climit - possible solution limit
%           plimit - pivot limit
%           sigm - standard deviation of measurement error
%           sigx - sigma bound for angle recognition (recommend 3)
%
% OUTPUT:   Results - structure with result
%
% SUBROUTINES REQUIRED: PlotInFOV.m
%                       BTreeAdd.m
%                       BTreeFind.m
%
% =========================================================================

function Results = MatchStarsWAngs( StarsInFOV, climit, plimit, sigm, sigx );

global gmode Ang nAng AngPtr Kvec FOV FOVmax

nStarsInFOV = size( StarsInFOV, 2 );

% IF LESS THAN TWO STARS, ANGLES CANNOT BE MADE 

if nStarsInFOV < 2
    nCombs = 0;
    Combs = [];
    Results.nPivots = 0;
    Results.nFinalists = [];
    Results.Match = [];
    '-- NOT ENOUGH STARS --'
else
    nCombs = nchoosek( nStarsInFOV, 2 )
    
    % CREATE LIST OF ANGLES, INCL. AREA, AND MAX & MIN TRIANGLE INDICIES
    
    clear A;
    k = 0;
    start = 1;
    maxAng = 0;    
    
    for s1=1:nStarsInFOV-1
        sv1 = StarsInFOV(s1).mv;
        for s2=s1+1:nStarsInFOV
            sv2 = StarsInFOV(s2).mv;
            
            %[sv1 sv2]
                
            mDotPr = dot( sv1, sv2 );
            mAng   = acos( mDotPr );
            
            %[mDotPr mAng mAng*180/pi]
            
            if mAng > pi/2
                mAng = pi - mAng;
            end
                
            if mAng < FOVmax
            
                Amin = mAng - sigm*sigx*sqrt(2);    
                Amax = mAng + sigm*sigx*sqrt(2);
                
                imin = FindWithLinKvec( cos(Amax), Kvec );
                imax = FindWithLinKvec( cos(Amin), Kvec );
                
                range = imax - imin;
                
                if range <= climit      % Only keep with tris within combo limit
                    k = k + 1;
                    A(k).Stars = [ s1 s2 ];
                    A(k).mAng = mAng;
                    A(k).mDotPr = mDotPr;
                    A(k).imin = imin;
                    A(k).imax = imax;
                    A(k).llist = 0;           % Used for linked list
                    
                    if A(k).mAng > maxAng
                        start = k;
                        maxAng = A(k).mAng;
                    end

                end
                
            end
            
        end
    end
    nCombs = k
    
    % CREATE LINKED LIST OF TRIANGLES, SUCH THAT NO MORE THAN ONE STAR CHANGES AT A TIME
    % GIVING PRIORITY TO TRIANGLES WITH SMALLEST RANGE OF POSSIBLE SOLUTIONS
    
    A(start).llist = 999;       % makes ineligible (also EOL)
    prev = start;
    next = start;
    nPivots = 0;
    for j=1:nCombs
        maxAng = 0;
        done = false;
        
        for k=1:nCombs
            if A(k).llist == 0
                x = 0;
                for m=1:2
                    switch A(k).Stars(m)
                        case A(prev).Stars(1)
                            x = x + 1;
                        case A(prev).Stars(2)
                            x = x + 1;
                    end
                end
                if x == 1
                    if A(k).mAng > maxAng
                        next = k;
                        maxAng = A(k).mAng;
                    end
                    done = true;
                end
            end
        end
        
        A(prev).llist = next;
        A(next).llist = 999;
        prev = next;           
        
        if done == true
            nPivots = nPivots + 1;
            if nPivots == plimit
                break;
            end
        else
            break;              
        end
    end
    
    nPivots = nPivots
    
    % Start with triangle with fewest possible solutions (first in list)

    if nCombs > 0         
        nFinalists = A(start).imax - A(start).imin
        
        for j=1:nFinalists
            anum = AngPtr( A(start).imin+j-1 );
            Finalists(j).Ang = anum;
            Finalists(j).Stars = Ang( anum ).Stars;
        end
        
        Results.nFinalists = nFinalists;
        
        if bitand( gmode, 2 ) == 2           
            sv1 = StarsInFOV( A(start).Stars(1) ).mv;
            sv2 = StarsInFOV( A(start).Stars(2) ).mv;
            PlotInFOV( sv1, sv2, FOV, 0, '-g' );
            PlotInFOV( sv2, sv1, FOV, 0, '-g' );
        end
    else
        nFinalists = 0;
        Results.nFinalists = 0;
    end 
    
    % PIVOT AS REQUIRED TO NARROW POSSIBLE SOLUTIONS
    
    fail = 0;
    k = A(start).llist;
    
    for j=1:nPivots
        
        % If combinations reduce to 0, search has failed
        % If combinations reduce to 1, search is complete
        
%         WaitForKeyPress;    % Use to stop at every pivot
        
        switch nFinalists
            case 0
                %                     '-- FAILED SEARCH --'
                %                     fail = 1;
                nPivots = j - 1;
                break;
            case 1
                nPivots = j - 1;
                break;
        end
        
        % Plot in FOV as desired (bit 2 of gmode set)
        
        if bitand( gmode, 2 ) == 2
            PlotInFOV( sv1, sv2, FOV, 0, '-b' );
            PlotInFOV( sv2, sv1, FOV, 0, '-b' );
            sv1 = StarsInFOV( A(k).Stars(1) ).mv;
            sv2 = StarsInFOV( A(k).Stars(2) ).mv;
            PlotInFOV( sv1, sv2, FOV, 0, '-g' );
            PlotInFOV( sv2, sv1, FOV, 0, '-g' );
        end 
        
        [ j (A(k).imax - A(k).imin) ]
        Results.nFinalists = [ Results.nFinalists (A(k).imax - A(k).imin) ];
                
        % Compare current finalists to possible stars that match
        % current triangle. Keep those triangles that share two stars.
        
        % Put stars in to binary tree
        
        saTree = [];
        sbTree = [];
        
        for b = A(k).imin:A(k).imax
            anum = AngPtr(b);
            
            saTree = BTreeAdd( Ang(anum).Stars(1), anum, saTree );
            sbTree = BTreeAdd( Ang(anum).Stars(2), anum, sbTree );
            
        end        
        
        n1 = 0;
        F1 = [];
        for a = 1:nFinalists    % Go through current finalists
            s1 = Finalists(a).Stars(1,1);
            s2 = Finalists(a).Stars(1,2);
            
            match = [];

            p = BTreeFind( s1, saTree );
            for b = 1:size(p,2)
                c = saTree( p(b) ).Data;
                match = [c match];
            end
            
            p = BTreeFind( s2, saTree );
            for b = 1:size(p,2)
                c = saTree( p(b) ).Data;
                match = [c match];
            end
            
            p = BTreeFind( s1, sbTree );
            for b = 1:size(p,2)
                c = saTree( p(b) ).Data;
                match = [c match];
            end
            
            p = BTreeFind( s2, sbTree );
            for b = 1:size(p,2)
                c = saTree( p(b) ).Data;
                match = [c match];
            end

                for b=1:size(match,2)
                    n1 = n1 + 1;
                    F1(n1).Ang   = [ match(b); Finalists(a).Ang ];
                    F1(n1).Stars = [ Ang( match(b) ).Stars; Finalists(a).Stars ];                                              
                end

                if n1 > nFinalists
                    nPivots = j - 1;
                    break;
                end
                            
            if n1 > nFinalists
                break;
            end
            
        end
                
        if n1 > nFinalists
            break;
        end
        
        Finalists = F1;     % New list (F1) becomes current finalists
        nFinalists = n1
        
        k = A(k).llist;     % Advance to next combination in linked list     
    end
    
    % COMPILE RESULTS
        
    Results.nPivots = nPivots;
    
    switch nFinalists
        case 0
            '-- NO SOLUTION --'
            Results.Match = [];
            nResults = 0;
        case 1
            Results.Match = Finalists(1).Stars(1,1:2);
            n1 = 2;
            for j=2:nPivots+1
                for k = 1:2
                    match = false;
                    for m=1:n1
                        if Finalists(1).Stars(j,k) == Results.Match(m)
                            match = true;
                            break;
                        end
                    end
                    if match == false
                        Results.Match = [ Results.Match Finalists(1).Stars(j,k) ];
                        n1 = n1 + 1;
                    end
                end
            end
            nResults = n1;
        otherwise
            '-- INCONCLUSIVE RESULTS --'
            Results.Match = [];
            nResults = 0;                               
    end
end