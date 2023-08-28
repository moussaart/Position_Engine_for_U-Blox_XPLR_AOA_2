%{
Function "inv_Triangulation"
The "inv_Triangulation" function is a MATLAB function that performs the 
inverse of triangulation. While the "triangulation" function estimates the 
tag's position from angles and anchor coordinates, the "inv_Triangulation" 
function determines arrival angles from the tag's coordinates and reference 
anchor locations. This function is particularly useful in localization and
 navigation systems to calculate arrival angles of received signals from 
different sources (anchors) to estimate the tag's position.

Inputs:

x: A 2x1 vector (or a 2xN matrix) representing the 2D coordinates of the tag's position.
y: A 2x1 vector (or a 2xN matrix) representing the 2D coordinates of the tag's position.
ref_points: A matrix of size 3xN (or Nx3) where N is the number of anchors.
 Each column represents the 2D coordinates (x, y) of a reference anchor.

Output:

angles: A vector (or matrix) containing the estimated arrival angles between
the tag and each anchor. The angles are usually expressed in the same unit (e.g., radians).
%}
function angles = inv_Triangulation(x, y, ref_points)
    angles1 = [];
    N = length(ref_points);
    n = size(x, 1);
    
    % Iterate over each anchor to calculate arrival angles
    for i = 1:N
        x_i = ref_points(i, 1);
        y_i = ref_points(i, 2);
        
        % Calculate the angle of arrival between tag and anchor
        angle = atan2(y - y_i, x - x_i);
        angles1 = [angles1; angle];
    end
    
    % Reshape the calculated angles into a matrix if needed
    angles = reshape(angles1, n, N);
end
