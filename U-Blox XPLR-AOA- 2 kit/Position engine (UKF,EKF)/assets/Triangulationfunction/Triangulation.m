%{
Function "Triangulation"
The "Triangulation" function is a MATLAB function that determines the position 
of a tag based on angles and coordinates of reference anchors. Triangulation 
is a geometric technique commonly used in localization systems to estimate 
the position of an object based on observed angles from multiple reference 
points.

Inputs:

angles: A vector (or matrix) containing the measured angles between the tag
 and each anchor. The angles should be expressed in the same unit (e.g., rad).

ref_points: A matrix 2xN (or Nx2) where N is the number of anchors. Each 
column represents the 2D coordinates (x, y) of a reference anchor.

Outputs:

x: The estimated x-coordinate of the tag's position.
y: The estimated y-coordinate of the tag's position.
%}
function [x, y] = Triangulation(angles, ref_points)
    % angles: List of angles between point A and each reference point
    % ref_points: List of reference points with known coordinates (x_i, y_i)
    
    N = length(ref_points);
    A = zeros(N, 2);
    b = zeros(N, 1);
    
    % Build the linear system of equations
    for i = 1:N
        angle = angles(i);
        x_i = ref_points(i, 1);
        y_i = ref_points(i, 2);
        A(i, :) = [sin(angle), -cos(angle)];
        b(i) = sin(angle) * x_i - cos(angle) * y_i;
    end
    
    
        % Solve the linear system using least squares
        AA = inv(A' * A);
        BB = A' * b;
        X = AA * BB;
        x = X(1);
        y = X(2);

end
