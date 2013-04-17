% =========================================================================
%
% StarAreaCov.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Determines variance of spherical triangle angle measurement.
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

function p_area = StarAreaCov( b1, b2, b3, sigm )

a=acos(b1'*b2);
b=acos(b2'*b3);
c=acos(b1'*b3);
s=0.5*(a+b+c);
area=4*atan(sqrt(tan(s/2)*tan((s-a)/2)*tan((s-b)/2)*tan((s-c)/2)));

sm=s;
am=a;
bm=b;
cm=c;

z2=tan(sm/2)*tan((sm-am)/2)*tan((sm-bm)/2)*tan((sm-cm)/2);
z=sqrt(z2);

u1=1/cos((am+bm+cm)/4)^2*tan((bm+cm-am)/4)*tan((am+cm-bm)/4)*tan((am+bm-cm)/4);
u2=tan((am+bm+cm)/4)/cos((bm+cm-am)/4)^2*tan((am+cm-bm)/4)*tan((am+bm-cm)/4);
u3=tan((am+bm+cm)/4)*tan((bm+cm-am)/4)/cos((am+cm-bm)/4)^2*tan((am+bm-cm)/4);
u4=tan((am+bm+cm)/4)*tan((bm+cm-am)/4)*tan((am+cm-bm)/4)/cos((am+bm-cm)/4)^2;

dzda=-1/8*z2^(-0.5)*(u1-u2+u3+u4);
dzdb=-1/8*z2^(-0.5)*(u1+u2-u3+u4);
dzdc=-1/8*z2^(-0.5)*(u1+u2+u3-u4);

% Note z2 can be neglected here               

h=4/(1+z2)*[dzda dzdb dzdc];

% cov(noise_area)

p_area=2*sigm^2*h*h';
