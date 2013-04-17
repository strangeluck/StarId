% =========================================================================
%
% FindWithParabKvec.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Returns spherical triangle ptr index using parabolic K-Vector
%
% INPUTS:   Val - area of spherical triangle
%           Kvec - K-Vector array, and equation of parabola.
%
% OUTPUT:   i - index
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

function i = FindWithParabKvec( Val, Kvec );

if Val < (Kvec.B + Kvec.A)
    Val = Kvec.B + Kvec.A;
end

x = floor( sqrt( (Val - Kvec.B)/Kvec.A ) );

if x == 0
    x = 1;
elseif x > size( Kvec.Ptr, 2 )
    x = size( Kvec.Ptr, 2 );
end

i = Kvec.Ptr(x);

% Scan upward through triangles until match is found

% while Prop(i) < Val
%     i = i + 1;
% end