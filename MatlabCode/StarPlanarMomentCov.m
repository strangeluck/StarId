% =========================================================================
%
% StarPlanarMomentCov.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING TRIANGLES
% Craig L Cole
% 12 January 2005
%
% Determines standard deviation of planar triangle polar moment measurement.
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

function var_moment = StarPlanarMomentCov( b1, b2, b3, sigm )

% [moment,sig_moment]=triangle_moment(b1,b2,b3,sig)
% 
% This program compute the planar moment from 3 star vector observations. 
% It also computes the standard deviation of the moment. 
% The inputs are: 
%   b1, b2, b3 = Three Body Vectors (each 3 x 1)
%          sig = Standard Devation of Measurement (1 x 1)   
%
% The outputs are:
%       moment = Planar Moment
%   sig_moment = Standard Deviation of Moment (sigma)
%   var_moment = Variation (sigma^2)

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

% Compute Moment
height=2*area/b;
moment=(b^3*height-b^2*height*a+b*height*a^2+b*height^3)/36;

% Compute Partials and Moment Standard Deviation
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

h1_area=darea_da*da_db1+darea_dc*dc_db1;
h2_area=darea_da*da_db2+darea_db*db_db2;
h3_area=darea_db*db_db3+darea_dc*dc_db3;

dj_da=(-b^3*area+2*a*b^2*area)/(18*b^2);
dj_db=(4*b^3*area-3*a*b^2*area+2*a^2*b*area)/(18*b^2)-(b^4*area-a*b^3*area+a^2*b^2*area+4*area^3)/(9*b^3);
dj_darea=(b^4-a*b^3+a^2*b^2+12*area^2)/(18*b^2);

h1=dj_da*da_db1+dj_darea*h1_area;
h2=dj_da*da_db2+dj_db*db_db2+dj_darea*h2_area;
h3=dj_db*db_db3+dj_darea*h3_area;
h=[h1 h2 h3];

var_moment=h*r*h';