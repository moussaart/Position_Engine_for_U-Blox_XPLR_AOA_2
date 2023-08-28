% Transition function for prediction: Predicts the next state based on the current state
% Inputs:
% - Xk: Current state vector [x, vx, y, vy]
% - dt: Time step interval between predictions
% Outputs:
% - Xk1: Predicted next state vector [x', vx', y', vy']

function Xk1 = transitionFcn(Xk, dt)
    % Define the state transition matrix A
    A = [1 dt 0  0;
         0  1 0  0;
         0  0 1 dt;
         0  0 0  1];
     
    % Perform the state prediction using the transition matrix
    Xk1 = A * Xk;
end
