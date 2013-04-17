% =========================================================================
%
% StarPlanarAreaCov.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING TRIANGLES
% Craig L Cole
% 12 January 2005
%
% Determines standard deviation of planar triangle area measurement.
%
% INPUTS:   b1 - vector to vertex 1
%           b2 - vector to vertex 2
%           b3 - vector to vertex 3
%           sigm - standard deviation of measurement
%
% OUTPUT:   p_area - variance of area measurement
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

function var_area = StarPlanarAreaCov( b1, b2, b3, sigm )

% [area,sig_area]=triangle_area(b1,b2,b3,sig)
% 
% This program compute the planar area from 3 star vector observations. 
% It also computes the standard deviation of the area. 
% The inputs are: 
%   b1, b2, b3 = Three Body Vectors (each 3 x 1)
%          sig = Standard Devation of Measurement (1 x 1)   
%
% The outputs are:
%         area = Planar Area
%     sig_area = Standard Deviation of Area (sigma) 
%     var_area = Variance of Area (sigma^2)

% John Crassidis 12/2/04

% Variables
b1=b1(:);b2=b2(:);b3=b3(:);
zero3=zeros(3);eye3=eye(3);

% Covaraince of Body Measurements
r1=sigm^2*(eye3-b1*b1');
r2=sigm^2*(eye3-b2*b2');
r3=sigm^2*(eye3-b3*b3');
r=[r1 zero3 zero3;zero3 r2 zero3;zero3 zero3 r3];

% More Accurate Covariance (only needed for very large FOV's)
%bore=[0;0;1];
%r1=sig^2*(bore'*b1)^2*(eye3-b1*b1'+(bore'*b1)^(-2)*cross(b1,bore)*cross(b1,bore)');
%r2=sig^2*(bore'*b2)^2*(eye3-b2*b2'+(bore'*b2)^(-2)*cross(b2,bore)*cross(b2,bore)');
%r3=sig^2*(bore'*b3)^2*(eye3-b3*b3'+(bore'*b3)^(-2)*cross(b3,bore)*cross(b3,bore)');
%r=[r1 zero3 zero3;zero3 r2 zero3;zero3 zero3 r3];

% Compute Area
a=norm(b1-b2);
b=norm(b2-b3);
c=norm(b1-b3);
s=0.5*(a+b+c);
area=sqrt(s*(s-a)*(s-b)*(s-c));

% Compute Partials and Area Standard Deviation
u1=(s-a)*(s-b)*(s-c);
u2=s*(s-b)*(s-c);
u3=s*(s-a)*(s-c);
u4=s*(s-a)*(s-b);

darea_da=(u1-u2+u3+u4)/(4*area);
darea_db=(u1+u2-u3+u4)/(4*area);
darea_dc=(u1+u2+u3-u4)/(4*area);

da_db1=(b1-b2)'/a;da_db2=-da_db1;
db_db2=(b2-b3)'/b;db_db3=-db_db2;
dc_db1=(b1-b3)'/c;dc_db3=-dc_db1;

h1=darea_da*da_db1+darea_dc*dc_db1;
h2=darea_da*da_db2+darea_db*db_db2;
h3=darea_db*db_db3+darea_dc*dc_db3;
h=[h1 h2 h3];

var_area=h*r*h';