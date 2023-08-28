function EKF=Inititaliztion_filter_EKF(x0,R,Q,ref_points,dt)

function XK = myStateTransitionFcn(x)
        XK = transitionFcn(x, dt);
end

    % Nested function definition for measurement
function z = myMeasurementFcn(xk)
        z = measurementFcn(xk, ref_points);
end
ekf=extendedKalmanFilter(@myStateTransitionFcn, @myMeasurementFcn, x0);
% Set the measurement noise covariance matrix (4x4) for the UKF
ekf.MeasurementNoise = eye(4) * R^2;

% Set the process noise covariance matrix (4x4) for the UKF using diagonal Q
ekf.ProcessNoise = diag(Q);

EKF=ekf;
end