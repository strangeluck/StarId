% =========================================================================
%
% RandAttTest.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Creates random attitude, determines stars in FOV, performs coordinate
% transform to put star positions into star tracker frame, adds error
% then tests either angle or spherical triangle method. Results are
% tabulated then saved.
%
% INPUTS:   Stars - star list
%           SphTri2xxxx - Catalog of Spherical Triangles w/area and Ip
%           SphTriPtr - Pointer array and K-Vec for Sph Tri Catalog
%           Angxxxx - Catalog of Angles
%           AngPtr - Pointer array and K-Vec for Angle Catalog
%
% OUTPUT:   Results - structure containing results of all tests
%
% SUBROUTINES REQUIRED: MatchStarsWAngs.m
%                       MatchStarsWSphTris.m
%                       PlotInFOV.m
%                       GetRandomVector.m
%                       GetBodyFrame.m
%                       PlotSphericalCap.m
%                       FindStarsInFOV.m
%                       CoordXform.m
%                       AddNoise.m
%                       WaitForKeyPress.m
%
% =========================================================================

clear all;

global nVertex nNodes Star nStars gmode
global Tri nTri TriPtr Ang nAng AngPtr Kvec
global trvector FOV FOVmax

Method = 2;             % Set to 1 for Angle Method, 2 for SphTri Method

ntests = 1000           % Number of tests

gmode = 7;              % Bit 1 = 3-D View of FOV
                        % Bit 2 = Star Tracker FOV
                        % Bit 3 = Wait between tests

FOV = 8 * pi/180;       % Star Tracker field of view
sigm = (87.2665e-6)/3;  % Measurement Standard Deviation
sigx = 3;               % Sigma bound for search
climit = 10000;         % Limit to number of combinations to pursue

load Stars;

switch Method
    case 1
        'ANGLE METHOD'
        load AngM60L4
        load AngPtrM60L4
        plimit = 9      % Pivot Limit
    case 2
        'SPHERICAL TRIANGLE METHOD'
        load SphTri2M60L4
        load SphTriPtrM60L4
        plimit = 3      % Pivot Limit
end
        
%
% LOOP THROUGH RANDOM ATTITUDES
%

for i = 1:ntests;
    i
    
    % Set-up 3-d plot if graphics are desired
    
    if bitand( gmode,1 ) == 1
        figure(1); 
        hold off;
        plot3( 0,0,0 ,'oy','MarkerSize',2);
        hold on;
        grid on;
    end
    
    % GET RANDOM TRACKER DIRECTION & ATTITUDE
    
    trvector = GetRandomVector;
    bframe   = GetBodyFrame( trvector );
    
    Results(i).trvector = trvector;
           
    if bitand( gmode,1 ) == 1
        PlotSphericalCap( trvector, FOV, 'b' );        
        plot3( [0 bframe.b1(1)], [0 bframe.b1(2)], [0 bframe.b1(3)],'b');
        plot3( [0 bframe.b2(1)*0.5], [0 bframe.b2(2)*0.5], [0 bframe.b2(3)*0.5],'b');
        plot3( [0 bframe.b3(1)*0.5], [0 bframe.b3(2)*0.5], [0 bframe.b3(3)*0.5],'b');
    end 
    
    % FIND STARS WITHIN FIELD OF VIEW    
    
    StarsInFOV = FindStarsInFOV( trvector, FOV );
    nStarsInFOV = size( [ StarsInFOV.Star ], 2 );
    [nStarsInFOV]
    
    % ADD MEASUREMENT ERROR TO STAR VECTORS
    
    for j=1:nStarsInFOV
        vi = Star( StarsInFOV(j).Star ).Vector;  % True vector
        vb = CoordXform( vi, bframe ) ;          % Convert to tracker frame
        vm = AddNoise( vb, sigm );               % Add noise (measured vector)
        
        StarsInFOV(j).tv = vb;
        StarsInFOV(j).mv = vm;
    end
    
    % Plot stars if desired
    
    if bitand( gmode, 2 ) == 2
        PlotInFOV( [0 0 0]', [0 0 0]', FOV, 1, 'm' );
        for j = 1:nStarsInFOV
            PlotInFOV( StarsInFOV(j).tv, StarsInFOV(j).tv, FOV, 0, 'ob' );
            PlotInFOV( StarsInFOV(j).mv, StarsInFOV(j).mv, FOV, 0, '+r' );
        end
    end   
    
    % MATCH UP STARS IN FOV USING SPHERICAL TRIANGLES
    
    t0 = cputime;
    switch Method
        case 1
            R1 = MatchStarsWAngs( StarsInFOV, climit, plimit, sigm, sigx );
        case 2
            R1 = MatchStarsWSphTris( StarsInFOV, climit, plimit, sigm, sigx );
    end
    t1 = cputime - t0

    Results(i).nPivots = R1.nPivots;
    Results(i).nFinalists = R1.nFinalists;
    Results(i).Match = R1.Match;
    Results(i).StarsInFOV  = [ StarsInFOV.Star ];
    Results(i).time = t1;
    nResults = size( Results(i).Match, 2 );
    
    % IF UNABLE TO MATCH, RECORD FAILURE
    
    Results(i).Fail = false;
    Results(i).Cant = false;
    if nStarsInFOV > Method
        if nResults == 0
            Results(i).Fail = true;
        end
    else
        Results(i).Cant= true;
    end
            
    % CHECK THAT RESULTS ARE CORRECT. IF NOT, RECORD ERROR.
        
    Results(i).Bad = false;
    Results(i).Correct = false;
    if nResults > 0
        for j=1:nResults
            found = 0;
            for k=1:nStarsInFOV
                if Results(i).Match(j) == StarsInFOV(k).Star
                    found = 1;
                    break;
                end
            end
            if found == 0
                break;
            end
        end
        if found == 0
            '-- INCORRECT RESULTS --'           
            Results(i).Bad = true;
        else
            '** CORRECT RESULTS **'
            Results(i).Correct = true;
        end               
    end
    
    Results(i)    
    
    if bitand( gmode, 4 ) == 4
        WaitForKeyPress;
    end
   
end

save Results Results
