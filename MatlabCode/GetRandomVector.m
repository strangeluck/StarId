% =========================================================================
%
% GetRandomVector.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Creates random unit vector in space
%
% INPUTS: none
%
% OUTPUT: v - random vector in cartesian coords
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

function v = GetRandomVector

% Random attitude in spherical coords

alpha = rand(1)*2*pi;       % Az:  Range from 0 to 360 degrees
beta = rand(1)*pi - pi/2;   % Alt: Range from -90 to 90 degrees

% Convert to cartesian coords    

v = [ cos( beta )*cos( alpha ); cos( beta )*sin( alpha ); sin( beta ) ];