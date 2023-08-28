% Measurement function: Calculates measured angles based on the current state and reference points
% Inputs:
% - Xk: Current state vector [x, vx, y, vy]
% - ref_points: Matrix of reference points [x_ref, y_ref] for triangulation
% Outputs:
% - zk: Vector of measured angles in radians

function zk = measurementFcn(Xk, ref_points)
    angles1 = [];  % Initialize an empty vector to store calculated angles
    
    N = length(ref_points);  % Number of reference points for triangulation
    
    % Iterate through each reference point to calculate the angles
    for i = 1:N
        x_i = ref_points(i, 1);  % X-coordinate of the reference point
        y_i = ref_points(i, 2);  % Y-coordinate of the reference point
        
        % Calculate the angle using atan2 based on the difference between state and reference point
        angle = atan2(Xk(3) - y_i, Xk(1) - x_i);
        
        angles1 = [angles1; angle];  % Append the calculated angle to the vector
    end
    
    zk = angles1;  % Return the vector of measured angles
end
