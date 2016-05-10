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

function shallExit=WaitForKeyPress();

shallExit = false;

ans = input ("Enter 'X' to exit, anything else to continue: ", "s");

if ans == "X" || ans == "x"
    fprintf("Exiting early.\n\n");
    shallExit = true;
else
    fprintf("Working...\n\n");
end