% =========================================================================
%
% FindWithLinKvec.m
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Returns angle ptr index using K-Vector
%
% INPUTS:   Val - angle
%           Kvec - K-Vector array, and equation of line.
%
% OUTPUT:   i - index
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

function i = FindWithLinKvec( Val, Kvec );

if Val < Kvec.B
    Val = Kvec.B;
end

x = floor( (Val - Kvec.B)/Kvec.A );

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