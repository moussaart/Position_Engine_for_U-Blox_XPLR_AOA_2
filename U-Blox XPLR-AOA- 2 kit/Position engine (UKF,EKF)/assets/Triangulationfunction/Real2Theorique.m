%{
Function "Real2Theorique"
The "Real2Theorique" function is a MATLAB function that transforms real angle 
measurements in space into theoretical angle measurements in the space defined
 by anchors. This transformation is commonly used in localization and navigation
 systems where measured angles need to be converted into a common reference 
space defined by anchor positions.

Inputs:

alpha: A vector (or matrix) containing the measured angles between the tag 
and each anchor. The angles should be expressed in the same unit (e.g., degrees).

Output:

Theta: A vector (or matrix) containing theoretical angles between the tag 
and each anchor, transformed into the theoretical space defined by the anchors.
%}
function Theta = Real2Theorique(alpha,orientation)
N = size(alpha, 1);
cst = ones(N, 1);
Theta = zeros(N, 4);

% Calculate theoretical angles based on measured angles
Theta(:, 1) = orientation(1) * cst - alpha(:, 1);
Theta(:, 2) = orientation(2) * cst - alpha(:, 2);
Theta(:, 3) = orientation(3)* cst - alpha(:, 3);
Theta(:, 4) = orientation(4) * cst - alpha(:, 4);
end
