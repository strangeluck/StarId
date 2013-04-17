% =========================================================================
%
% StripLowStarAttitudes.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 12 June 1005
%
% Removes attitudes from results that contain less than a specified number
% of stars.
%
% INPUTS:   Results*.mat
%
% OUTPUT:   Results*nMinStars.mat (where n = minimum number of stars)
%
% SUBROUTINES REQUIRED: (none)
%
% =========================================================================

load ResultsPlanarTriP2FS.mat

nStarsMin = 5;

% Go through all the results

j = 0;

for i=1:nResults
    nStarsInFOV = size( Results(i).StarsInFOV, 2 );
    
    if nStarsInFOV < nStarsMin
        
        Results(i) = [];
        
        j = j + 1;
    end
end

save Results