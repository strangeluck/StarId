% =========================================================================
%
% StarDistrib.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Determine the distributions of stars in over 1000 random attitudes
% given a FOV and magnitude limit. Brute force check of all stars to see if
% they are in the field of view. Good check of results of RandAttTest.m,
% since the dsitribution of stars should look alike. 
%
% INPUTS: Stars - list of stars
%
% OUTPUT:   none
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

clear;

vFOV = 8 * pi / 180         % Star Tracker Field of view (rads)
magLim = 6                  % Magnitude limit of star tracker
hmax = 20;                  % Lump all counts greater than hmax stars together.

load Stars                  % Load star catalog (ordered by magnitude)

ntests = 1000

tic

% Do ntests number of random attitudes and count stars in FOV

for i = 1:ntests
    i
    h(i) = 0;
    
    % Random attitude in spherical coords
    
    alpha = rand(1)*2*pi;
    beta = rand(1)*pi- pi/2;
    
    % Convert to cartesian
    
    x = [ cos( beta )*sin( alpha ); sin( beta ); cos( beta )*cos( alpha ) ];
        
    % Check all stars on lists to see if its in FOV
    
    for j = 1:nStars
        if Star(j).Mag >= magLim    % break j Loop at first overly dim star
            break
        else
            gamma = acos( dot( Star(j).Vector, x ) );
            if gamma <= vFOV / 2                          
                h(i) = h(i) + 1;    % Increment number of stars for that test
            end
        end
    end
    
    if h(i) > hmax+1                % All occurances above hmax are lumped together
        h(i) = hmax+1;
    end
end

% Create a histogram of results

nh=hist( h, 0:hmax+1 );
nhmax = max(nh)

figure(1)
hist( h, 0:hmax+1 )
xlabel('Stars in FOV')
ylabel('Occurances')
title('Number of Stars in FOV Based on Random Attitude Tests')
axis tight;

% Graph probability of seeing a certain number of stars within FOV

s(hmax+3)=0;
for i=hmax+2:-1:1
    s(i) = s(i+1)+nh(i);
    p(i) = s(i)/ntests*100;
end

figure(2)

bar(0:hmax+1,p)
xlabel('Minimum Number of Stars in FOV')
ylabel('Chance of occuring (%)')
title('Number of Stars in FOV Based on Random Attitude Tests')
axis tight;

toc