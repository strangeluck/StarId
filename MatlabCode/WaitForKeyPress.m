% =========================================================================
%
% TITLE.M
%
% THESIS: FAST STAR PATTERN RECOGNITION USING SPHERICAL TRIANGLES
% Craig L Cole
% 8 January 2003
%
% Waits for a key press. Ignores mouse clicks so that views can be
% manipulated. Requires at least one open plot to work.
%
% INPUTS:   none
%
% OUTPUT:   none
%
% SUBROUTINES REQUIRED: none
%
% =========================================================================

'Press A Key...'

w=0;

while w ~= 1;
    w = waitforbuttonpress;   
end