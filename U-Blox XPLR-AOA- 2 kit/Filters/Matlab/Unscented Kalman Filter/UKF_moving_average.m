% This function implements the UKF (Unscented Kalman Filter) for estimating 
% the position (X, Y) of a tag from noisy measurements.
% It also performs additional filtering for improved estimation accuracy.
%
% Inputs:
% - X0: Initial state of the tag (initial position) [x_initial, vx_initial, y_initial, vy_initial]
% - meassurment: Noisy measurements (observed data)
% - ref_points: Reference points for triangulation
% - R: Measurement noise covariance matrix
% - Q: Process noise covariance matrix
% - dt: Time interval between measurements
% - windowSize: Smoothing parameter (smoothing window size)
%
% Outputs:
% - Xout: Filtered (estimated) values of the robot's X position
% - Yout: Filtered (estimated) values of the robot's Y position
function [Xout, Yout] = UKF_moving_average(X0, meassurment, ref_points, R, Q, dt, windowSize)
    % Define the time interval between measurements
    DT = dt;

    % Nested function definition for state transition
    function XK = myStateTransitionFcn(x)
        XK = transitionFcn(x, DT);
    end

    % Nested function definition for measurement
    function z = myMeasurementFcn(xk)
        z = measurementFcn(xk, ref_points);
    end

    % Extract problem dimensions
    N = length(ref_points);
    T = size(meassurment, 1); % Number of iterations (measurements)
    timeSteps = 1:T;

    % Smoothing noisy measurements using moving average
    measurement0 = movmean(meassurment, windowSize);

    % Initialize the UKF filter with specified parameters
    alpha = 1;
    beta = 5;
    kappa = 3;

    ukf = unscentedKalmanFilter(@myStateTransitionFcn, @myMeasurementFcn, X0, ...
                               'alpha', alpha, 'beta', beta, 'kappa', kappa);
    ukf.MeasurementNoise = R;
    ukf.ProcessNoise = diag(Q);

    % Initialize matrix to store filtered states at each iteration
    filteredStates = zeros(N, T);

    % Main loop to apply UKF filter and perform smoothing
    for t = 1:T
        % Generate noisy measurements from the true state (with simulated noise added)

        % Noisy measurement at time t
        meas = measurement0(t,:)';

        % Prediction and correction using the UKF filter
        ukf.predict();
        [filteredState, ~] = correct(ukf, meas);

        % Store the filtered state at iteration t
        filteredStates(:, t) = filteredState;
    end

    % Additional smoothing (moving average) of the filtered states
    for i = 1:4
        % Apply moving average smoothing for each state component
        filteredStates(i, :) = movmean(filteredStates(i, :), windowSize);
    end

    % Calculate filtered measurements using inverse triangulation
    filterThetas = inv_Triangulation(filteredStates(1,:)', filteredStates(3,:)', ref_points);

    % Plotting results
    % Extract X and Y data
    X = zeros(T, 1);
    Y = zeros(T, 1);
    for t = 1:T 
        [xe, ye] = Triangulation(meassurment(t,:), ref_points);
        X(t) = xe;
        Y(t) = ye;
    end

    % Plot estimated (filtered) values and errors for each angle
    figure;
    orange = [255/255, 165/255, 0/255];
    for i = 1:N  
        switch i
            case 1
                subplot(2, 4, 1);
            case 2 
                subplot(2, 4, 2);
            case 3 
                subplot(2, 4, 5);
            case 4
                subplot(2, 4, 6);
        end 

        hold on 

        plot(timeSteps, meassurment(:, i), 'b--') % Noisy measurements
        plot(timeSteps, filterThetas(:, i), "Color", orange) % Filtered (estimated) measurements
        xlabel('Time Steps');
        ylabel(sprintf('Theta %d in rad', i));
        title(sprintf('Theta %d (t)', i));
        grid on;
    end 

    % Plot filtered (estimated) X position and errors
    subplot(2, 2, 2);
    hold on 
    plot(timeSteps, filteredStates(1, :), 'r--') % Filtered X (estimated)
    plot(timeSteps, X, 'b') % Actual X (measured)
    xlabel('Time Steps');
    ylabel('X Position');
    legend('Estimated', 'Error');
    title('Real-Time Plot');
    grid on;

    % Plot filtered (estimated) Y position and errors
    subplot(2, 2, 4);
    hold on 
    plot(timeSteps, filteredStates(3, :), 'r--') % Filtered Y (estimated)
    plot(timeSteps, Y, 'b') % Actual Y (measured)
    xlabel('Time Steps');
    ylabel('Y Position');
    legend('Estimated', 'Error');
    title('Real-Time Plot');
    grid on;

    % Prepare outputs Xout and Yout for further processing
    Xout = horzcat(X(100:T), filteredStates(1, 100:T)');
    Yout = horzcat(Y(100:T), filteredStates(3, 100:T)');
end
