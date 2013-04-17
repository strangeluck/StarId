% =========================================================================
%
% AddNoise.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 23 January 2005
%
% Adds measurement noise of a normal distribution to vector
%
% INPUTS:   b_true - body vector
%           sig    - measurement standard deviation
%
% OUTPUT:   b_meas - body vector with noise
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

function b_meas = AddNoise( b_true, sig );
%
% This progrma simulates the body measurements given 
% the truth and standard devation (scalar). All vectors 
% are assumed to be 3 x 1.

% John Crassidis 12/2/04

% Get Alpha and Beta
b_true=b_true(:);
alp=b_true(1)/b_true(3);
beta=b_true(2)/b_true(3);

% Add Noise
alp_meas=alp+sig*randn(1);
beta_meas=beta+sig*randn(1);

% Generate Vetcor Measurement
b_meas=1/sqrt(1+alp_meas^2+beta_meas^2)*[alp_meas;beta_meas;1];