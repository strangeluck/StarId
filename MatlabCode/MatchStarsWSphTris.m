% =========================================================================
%
% MatchStarsWSphTris.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Takes a list of stars in FOV, and tries to match up stars in catalog
% using spherical triangle method.
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
%                       CalcFOV.m
%
% =========================================================================

function Results = MatchStarsWSphTris( StarsInFOV, climit, plimit, sigm, sigx );

global gmode Tri nTri TriPtr Kvec FOV FOVmax

nStarsInFOV = size( StarsInFOV, 2 );

% IF LESS THAN THREE STARS, TRIANGLES CANNOT BE MADE 

if nStarsInFOV < 3
    nCombs = 0;
    Combs = [];
    Results.nPivots = 0;
    Results.nFinalists = [];
    Results.Match = [];
    '-- NOT ENOUGH STARS --'
else
    nCombs = nchoosek( nStarsInFOV, 3 )
    
    % CREATE LIST OF TRIANGLES, INCL. AREA, AND MAX & MIN TRIANGLE INDICIES
    
    clear T;
    k = 0;
    start = 1;
    maxProp = 0;    
    
    % Create array of Triangles in FOV, including range of possible
    % solutions from Triangle Catalog using K-Vector
    
    for s1=1:nStarsInFOV-2
        sv1 = StarsInFOV(s1).mv;
        for s2=s1+1:nStarsInFOV-1
            sv2 = StarsInFOV(s2).mv;
            
            mAng = acos( dot( sv1, sv2 ) );
            
            if mAng > pi/2
                mAng = pi - mAng;
            end
            
            if mAng <= FOVmax
                
                for s3=s2+1:nStarsInFOV
                    sv3 = StarsInFOV(s3).mv;
                    
                    mFOV = CalcFOV( sv1, sv2, sv3 );  % Determine if skinny
                    if mFOV <= FOVmax
                        
                        % Measure area of triangle, determine bounds on
                        % error
                        
                        Prop = SphTriArea( sv1, sv2, sv3 );
                        var  = StarAreaCov( sv1, sv2, sv3, sigm );
                        
                        % Calculate minimum and maximum areas
                        
                        PropMin = Prop - sigx * sqrt(var);                
                        PropMax = Prop + sigx * sqrt(var);
                        
                        % Determine ranges of possible solutions using K-Vector
                        
                        pmin = FindWithParabKvec( PropMin, Kvec );
                        pmax = FindWithParabKvec( PropMax, Kvec );
                        range = pmax - pmin;
                        
                        if range <= climit      % Only keep tri list within combo limit
                            k = k + 1;
                            T(k).Stars = [ s1 s2 s3 ];
                            T(k).Prop  = Prop;
                            T(k).Prop2 = -1;    % Don't fill till needed
                            T(k).pmin  = pmin;
                            T(k).pmax  = pmax;
                            T(k).llist = 0;     % Used for linked list
                            
                            % Find Triangle with greatest area to start list
                            
                            if T(k).Prop > maxProp
                                start = k;
                                maxProp = T(k).Prop;
                            end
                        end
                    end
                end
            end
        end
    end
    nCombs = k
    
    % CREATE LINKED LIST OF TRIANGLES IN FOV, SUCH THAT NO MORE THAN
    % ONE STAR CHANGES AT A TIME GIVING PRIORITY TO TRIANGLES WITH 
    % LARGEST POSSIBLE AREASS
    
    T(start).llist = 999;       % makes ineligible (also EOL)
    prev = start;
    next = start;
    nPivots = 0;
    for j=1:nCombs
        maxProp = 0;
        done = false;
        
        for k=1:nCombs
            if T(k).llist == 0
                x = 0;
                for m=1:3
                    switch T(k).Stars(m)
                        case T(prev).Stars(1)
                            x = x + 1;
                        case T(prev).Stars(2)
                            x = x + 1;
                        case T(prev).Stars(3)
                            x = x + 1;
                    end
                end
                if x == 2       % At least two common pts
                    if T(k).Prop > maxProp
                        next = k;
                        maxProp = T(k).Prop;
                    end
                    done = true;
                end
            end
        end
        
        T(prev).llist = next;
        T(next).llist = 999;    % EOL
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
    
    % Start with triangle with highest property value 
    
    if nCombs > 0         
        nFinalists = T(start).pmax - T(start).pmin
        
        k = 0;
        
        % Get Ic of first triangle, find range of allowable Ic
        
        s1  = T(start).Stars(1);
        s2  = T(start).Stars(2);
        s3  = T(start).Stars(3);
        sv1 = StarsInFOV(s1).mv;
        sv2 = StarsInFOV(s2).mv;
        sv3 = StarsInFOV(s3).mv;               
        T(start).Prop2 = SphTriPolarMoment( sv1, sv2, sv3, 3, 0, 0 );
        var = 3*((7.14e-4)*T(start).Prop2 + 3e-9);
        Prop2min = T(start).Prop2 - var;
        Prop2max = T(start).Prop2 + var;

        for j=1:nFinalists
            tnum = TriPtr( T(start).pmin+j-1 );
            
            % Include only if Ic is within allowable range

            if Tri(tnum).Ip >= Prop2min
                if Tri(tnum).Ip <= Prop2max
                    k = k + 1;
                    Finalists(k).Tri   = tnum;
                    Finalists(k).Stars = Tri(tnum).Stars;
                end
            end
        end
        nFinalists = k
        Results.nFinalists = k;
        
        if bitand( gmode, 4 ) == 4            
            sv1 = StarsInFOV( T(start).Stars(1) ).mv;
            sv2 = StarsInFOV( T(start).Stars(2) ).mv;
            sv3 = StarsInFOV( T(start).Stars(3) ).mv;            
            PlotInFOV( sv1, sv2, FOV, 0, '-g' );
            PlotInFOV( sv2, sv3, FOV, 0, '-g' );
            PlotInFOV( sv3, sv1, FOV, 0, '-g' );
            PlotInFOV( sv1, sv2, FOV, 0, '-g' );
        end
    else
        nFinalists = 0;
        Results.nFinalists = 0;
    end 
    
    % ==============================================
    % PIVOT AS REQUIRED TO NARROW POSSIBLE SOLUTIONS
    % ==============================================
    
    fail = 0;
    k = T(start).llist;
    
    for j=1:nPivots
        
        % If number of finalists reduces to 0, search has failed
        % If number of finalists reduces to 1, search is complete
        
%         WaitForKeyPress;  % Use to stop at every pivot
        
        switch nFinalists
            case 0
                nPivots = j - 1
                break;
            case 1
                nPivots = j - 1
                break;
        end
        
        % Plot in FOV as desired (bit 3 of gmode set)
        
        if bitand( gmode, 4) == 4
            PlotInFOV( sv1, sv2, FOV, 0, '-b' );
            PlotInFOV( sv2, sv3, FOV, 0, '-b' );
            PlotInFOV( sv3, sv1, FOV, 0, '-b' );
            PlotInFOV( sv1, sv2, FOV, 0, '-b' );
            sv1 = StarsInFOV( T(k).Stars(1) ).mv;
            sv2 = StarsInFOV( T(k).Stars(2) ).mv;
            sv3 = StarsInFOV( T(k).Stars(3) ).mv;
            PlotInFOV( sv1, sv2, FOV, 0, '-g' );
            PlotInFOV( sv2, sv3, FOV, 0, '-g' );
            PlotInFOV( sv3, sv1, FOV, 0, '-g' );
            PlotInFOV( sv1, sv2, FOV, 0, '-g' );
        end 
        
        [ j (T(k).pmax - T(k).pmin) ]
        Results.nFinalists = [ Results.nFinalists (T(k).pmax - T(k).pmin) ];
        
        % Create three binary trees of possible triangles, 
        % sorted by first star, second start and third star
        
        saTree = [];
        sbTree = [];
        scTree = []; 
        
        s1  = T(k).Stars(1);
        s2  = T(k).Stars(2);
        s3  = T(k).Stars(3);
        sv1 = StarsInFOV(s1).mv;
        sv2 = StarsInFOV(s2).mv;
        sv3 = StarsInFOV(s3).mv;               
        T(k).Prop2 = SphTriPolarMoment( sv1, sv2, sv3, 3, 0, 0 );
        var = 3*((7.14e-4)*T(start).Prop2 + 3e-9);
        Prop2min = T(k).Prop2 - var;
        Prop2max = T(k).Prop2 + var;
   
        for b = T(k).pmin:T(k).pmax
            tnum = TriPtr(b);
            
            % Add only those with correct range of Ic
            
            if Tri(tnum).Ip >= Prop2min
                if Tri(tnum).Ip <= Prop2max
                    saTree = BTreeAdd( Tri( tnum ).Stars(1), tnum, saTree );
                    sbTree = BTreeAdd( Tri( tnum ).Stars(2), tnum, sbTree );
                    scTree = BTreeAdd( Tri( tnum ).Stars(3), tnum, scTree );
                end
            end                
        end
        
        F1 = [];    % Reset list of finalists
        n1 = 0;
        
        for a = 1:nFinalists
            s1 = Finalists(a).Stars(1,1);
            s2 = Finalists(a).Stars(1,2);
            s3 = Finalists(a).Stars(1,3);    
            
            match = [];
            
            % Find triangles that have s1 in 1st position.
            % Of those, if s2 is in 2nd or 3rd position it's a match.
            % Or, if s3 is in 2nd or 3rd position it's a match.
            
            p = BTreeFind( s1, saTree );
            for b = 1:size(p,2)            
                c = saTree( p(b) ).Data;
                switch s2
                    case Tri( c ).Stars(2)
                        match = [ c match ];
                    case Tri( c ).Stars(3)
                        match = [ c match ];
                    otherwise
                        switch s3
                            case Tri( c ).Stars(2)
                                match = [ c match ];
                            case Tri( c ).Stars(3)
                                match = [ c match ];
                        end
                end
            end
            
            % Find triangles that have s1 in 2nd position.
            % Of those, if s2 is in 1st or 3rd position it's a match.
            % Or, if s3 is in 1st or 3rd position it's a match.
            
            p = BTreeFind( s1, sbTree );     
            for b = 1:size(p,2)   
                c = sbTree( p(b) ).Data;
                switch s2
                    case Tri( c ).Stars(1)
                        match = [ c match ];
                    case Tri( c ).Stars(3)
                        match = [ c match ];
                    otherwise
                        switch s3
                            case Tri( c ).Stars(1)
                                match = [ c match ];
                            case Tri( c ).Stars(3)
                                match = [ c match ];
                        end
                end
            end
            
            % Find triangles that have s1 in 3rd position.
            % Of those, if s2 is in 1st or 2nd position it's a match.
            % Or, if s3 is in 1st or 2nd position it's a match.
            
            p = BTreeFind( s1, scTree );
            for b = 1:size(p,2)       
                c = scTree( p(b) ).Data;
                switch s2
                    case Tri( c ).Stars(1)
                        match = [ c match ];
                    case Tri( c ).Stars(2)
                        match = [ c match ];
                    otherwise
                        switch s3
                            case Tri( c ).Stars(1)
                                match = [ c match ];
                            case Tri( c ).Stars(2)
                                match = [ c match ];
                        end
                end
            end
            
            % Find triangles that have s2 in 1st position.
            % Of those, if s3 is in 2nd or 3rd position it's a match.
            
            p = BTreeFind( s2, saTree );
            for b = 1:size(p,2)    
                c = saTree( p(b) ).Data;
                switch s3
                    case Tri( c ).Stars(2)
                        match = [ c match ];
                    case Tri( c ).Stars(3)
                        match = [ c match ];
                end
            end
            
            % Find triangles that have s2 in 2nd position.
            % Of those, if s3 is in 1st or 3rd position it's a match.            
            
            p = BTreeFind( s2, sbTree );
            for b = 1:size(p,2) 
                c = sbTree( p(b) ).Data;
                switch s3
                    case Tri( c ).Stars(1)
                        match = [ c match ];
                    case Tri( c ).Stars(3)
                        match = [ c match ];
                end
            end
            
            % Find triangles that have s2 in 3rd position.
            % Of those, if s2 is in 1st or 2nd position it's a match.
            
            p = BTreeFind( s2, scTree );
            for b = 1:size(p,2) 
                c = scTree( p(b) ).Data;
                switch s3
                    case Tri( c ).Stars(1)
                        match = [ c match ];
                    case Tri( c ).Stars(2)
                        match = [ c match ];
                end
            end
            
            for b=1:size(match,2)
                n1 = n1 + 1;
                F1(n1).Tri   = [ match(b); Finalists(a).Tri ];
                F1(n1).Stars = [ Tri( match(b) ).Stars; Finalists(a).Stars ];                                              
            end
            
            if n1 > nFinalists
                nPivots = j - 1;
                break;
            end
            
        end
        
        % If no of finalists increases from previous round, abandon matching
        
        if n1 > nFinalists
            break;
        end
        
        % Newly created list (F1) becomes current finalists
        
        Finalists = F1;     
        nFinalists = n1
        
        % Advance to next combination in linked list 
        
        k = T(k).llist;         
    end
    
    % COMPILE RESULTS
    
    Results.nPivots = nPivots;
    
    switch nFinalists
        case 0      % Search failed to match triangle
            '-- NO SOLUTION --'
            Results.Match = [];
            nResults = 0;
        case 1      % Search successful, create array of stars in FOV
            Results.Match = Finalists(1).Stars(1,1:3);
            n1 = 3;
            for j=2:nPivots+1
                for k = 1:3
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
        otherwise   % Unable to reduce possible solutions to one
            '-- INCONCLUSIVE RESULTS --'
            Results.Match = [];
            nResults = 0;                               
    end
end