% =========================================================================
%
% CompileResults.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
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

load Results
nResults = size( Results, 2 );

% Initialize variables for histograms

slim = 20       % Max number of stars to
fail(1:slim+1) = 0;
bad(1:slim+1) = 0;
correct(1:slim+1) = 0;
cant(1:slim+1) = 0;

tlim = 20       % Max number of seconds  
timeFail(1:tlim+1) = 0;
timeBad(1:tlim+1) = 0;
timeCorrect(1:tlim+1) = 0;
timeCant(1:tlim+1) = 0;

plim = 20       % Max number of pivots
pivotFail(1:tlim+1) = 0;
pivotBad(1:tlim+1) = 0;
pivotCorrect(1:tlim+1) = 0;
pivotCant(1:tlim+1) = 0;

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
        
        t0 = round( Results(i).time + 1 );
        if t0 > tlim+1
            t0 = tlim+1;
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
ylabel('Occurances')
axis tight;

% Pie chart of overall results

failsum = sum( fail(1:slim+1) );
badsum = sum( bad(1:slim+1) );
correctsum = sum( correct(1:slim+1) );
cantsum = sum( cant(1:slim+1) );    

figure(2);
pie( [ correctsum, cantsum, failsum, badsum ], [ 1 0 0 0 ] );

% Histogram for CPU time required vs. Occurances

figure(3);
bar( 0:tlim, [timeCorrect; timeCant; timeFail; timeBad]','stacked' );
xlabel('Time Required (sec)');
ylabel('Occurances')
axis tight;
timemean = mean([Results.time])
timestd  = std([Results.time])
timemed  = median([Results.time])

% Histogram for pivots vs occurances

figure(4);
bar( 0:plim, [pivotCorrect; pivotCant; pivotFail; pivotBad]','stacked' );
xlabel('Pivots Required');
ylabel('Occurances')
axis tight;
pivotmean = mean([Results.nPivots])
pivotstd  = std([Results.nPivots])
pivotmed  = median([Results.nPivots])