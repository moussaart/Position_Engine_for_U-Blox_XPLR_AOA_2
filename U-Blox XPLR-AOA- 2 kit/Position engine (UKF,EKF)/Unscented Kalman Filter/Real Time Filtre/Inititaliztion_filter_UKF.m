function UKF=Inititaliztion_filter_UKF(x0,alpha,beta,kappa,R,Q,ref_points,dt)

function XK = myStateTransitionFcn(x)
        XK = transitionFcn(x, dt);
end

    % Nested function definition for measurement
function z = myMeasurementFcn(xk)
        z = measurementFcn(xk, ref_points);
end
ukf=unscentedKalmanFilter(@myStateTransitionFcn, @myMeasurementFcn, x0, ...
                           'alpha', alpha, 'beta', beta, 'kappa', kappa);
% Set the measurement noise covariance matrix (4x4) for the UKF
ukf.MeasurementNoise = eye(4) * R^2;

% Set the process noise covariance matrix (4x4) for the UKF using diagonal Q
ukf.ProcessNoise = diag(Q);

UKF=ukf;
end