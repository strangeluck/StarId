% =========================================================================
%
% AddNoise.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Adds measurement noise of a normal distribution to vector
%
% INPUTS:   vt - true vector
%           sigm - measurement standard deviation
%
% OUTPUT:   vm - measurement of vector
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

function vm = AddNoise( vt, sigm );

vm = vt + sigm * randn( 3, 1 );
vm = vm / norm( vm );