% =========================================================================
%
% CompileResults.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 25 February 2005
%
% Creates histograms, pie charts, etc of results.
%
% INPUTS:   Resultsxxxx - Output of RandAttTest.m
%
% OUTPUT:   none
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

clear all;
% =========================================================================
%
% CompileResults.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 12 June 1005
%
% Compiles output of RandAttTest and constructs graphs of results
%
% INPUTS:   Results*.mat
%
% OUTPUT:   (none)
%
% SUBROUTINES REQUIRED: (none)
%
% =========================================================================

load ResultsAngP9FSMin5.mat

T = 'Angle Method, 9-Pivot Limit, False Star Included, 5-star Attitude Minimum';

% Initialize variables for histograms

nResults = size( Results, 2 );

slim = 20       % Max number of stars to
fail(1:slim+1) = 0;
bad(1:slim+1) = 0;
correct(1:slim+1) = 0;
cant(1:slim+1) = 0;

tlim = 10       % Max number of seconds 
tbins = 20
timeFail(1:tbins+1) = 0;
timeBad(1:tbins+1) = 0;
timeCorrect(1:tbins+1) = 0;
timeCant(1:tbins+1) = 0;

plim = 10       % Max number of pivots
pivotFail(1:plim+1) = 0;
pivotBad(1:plim+1) = 0;
pivotCorrect(1:plim+1) = 0;
pivotCant(1:plim+1) = 0;

% Go through all the results

for i=1:nResults
    nStarsInFOV = size( Results(i).StarsInFOV, 2 );
    
    if nStarsInFOV >= 0
        
        % Histogram for stars in FOV vs. Occurances
        
        if nStarsInFOV > slim
            nStarsInFOV = slim;
        end
        
        fail(nStarsInFOV+1)    = fail(nStarsInFOV+1)    + Results(i).Fail;
        bad(nStarsInFOV+1)     = bad(nStarsInFOV+1)     + Results(i).Bad;
        correct(nStarsInFOV+1) = correct(nStarsInFOV+1) + Results(i).Correct;
        cant(nStarsInFOV+1)    = cant(nStarsInFOV+1)    + Results(i).Cant;
        
        t0 = round( Results(i).time * tbins / tlim ) + 1;
        if t0 > (tbins + 1)
            t0 = tbins + 1;
        end
        
        timeFail(t0)    = timeFail(t0)    + Results(i).Fail;
        timeBad(t0)     = timeBad(t0)     + Results(i).Bad;
        timeCorrect(t0) = timeCorrect(t0) + Results(i).Correct;   
        timeCant(t0)    = timeCant(t0)    + Results(i).Cant; 
        
        p0 = Results(i).nPivots + 1;
        if p0 > plim + 1
            p0 = plim + 1;
        end
        
        pivotFail(p0)    = pivotFail(p0)    + Results(i).Fail;
        pivotBad(p0)     = pivotBad(p0)     + Results(i).Bad;
        pivotCorrect(p0) = pivotCorrect(p0) + Results(i).Correct;   
        pivotCant(p0)    = pivotCant(p0)    + Results(i).Cant;           
        
    end
    
end

figure(1);
bar( 0:slim, [correct; cant; fail; bad]','stacked' );
xlabel('Number of Stars in Field of View');
ylabel('Occurances');
axis tight;
legend( 'Correct Result','Too Few Stars','Inconclusive Result','Incorrect Result' );
title( T );

set( gcf, 'PaperPositionMode', 'manual' );
set( gcf, 'PaperUnits','inches' );
set( gcf, 'PaperPosition',[1.25 3.25 6.0 4.5] );

% Pie chart of overall results

failsum = sum( fail(1:slim+1) );
badsum = sum( bad(1:slim+1) );
correctsum = sum( correct(1:slim+1) );
cantsum = sum( cant(1:slim+1) );    

figure(2);
pie( [ correctsum, cantsum, failsum, badsum ], [ 1 0 0 0 ] );
legend( 'Correct Result','Too Few Stars','Inconclusive Result','Incorrect Result' );
title( T );

set( gcf, 'PaperPositionMode', 'manual' );
set( gcf, 'PaperUnits','inches' );
set( gcf, 'PaperPosition',[1.25 3.25 6.0 4.5] );

% Histogram for CPU time required vs. Occurances

timemean = mean([Results.time])
timestd  = std([Results.time])
timemed  = median([Results.time])

figure(3);
bar( 0:tlim/tbins:tlim, [timeCorrect; timeCant; timeFail; timeBad]','stacked' );
xlabel('Time Required (sec)');
ylabel('Occurances')
axis tight;
legend( 'Correct Result','Too Few Stars','Inconclusive Result','Incorrect Result' );
title( T );

T1 = ['Mean      = ' num2str(timemean,4) 10 ...
      'Std Dev = ' num2str(timestd,4) 10 ...
      'Median   = ' num2str(timemed,4) ];
text(0,0,T1)

set( gcf, 'PaperPositionMode', 'manual' );
set( gcf, 'PaperUnits','inches' );
set( gcf, 'PaperPosition',[1.25 3.25 6.0 4.5] );

text

% Histogram for pivots vs occurances

pivotmean = mean([Results.nPivots])
pivotstd  = std([Results.nPivots])
pivotmed  = median([Results.nPivots])

figure(4);
bar( 0:plim, [pivotCorrect; pivotCant; pivotFail; pivotBad]','stacked' );
xlabel('Pivots Required');
ylabel('Occurances')
axis tight;
legend( 'Correct Result','Too Few Stars','Inconclusive Result','Incorrect Result' )
title( T )

T1 = ['Mean      = ' num2str(pivotmean,4) 10 ...
      'Std Dev = ' num2str(pivotstd,4) 10 ...
      'Median   = ' num2str(pivotmed,4) ];
text(0,0,T1)

set( gcf, 'PaperPositionMode', 'manual' );
set( gcf, 'PaperUnits','inches' );
set( gcf, 'PaperPosition',[1.25 3.25 6.0 4.5] );
