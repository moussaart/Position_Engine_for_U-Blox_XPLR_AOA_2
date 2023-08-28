% This function implements the UKF (Unscented Kalman Filter) with 
% RTS (Rauch-Tung-Striebel) smoothing to estimate the position (X, Y) of 
% a tag from noisy measurements.
% It applies online smoothing using the RTS technique to improve the estimation.

% Inputs:
% - X0: Initial state of the tag (initial position) [x_initial, vx_initial, y_initial, vy_initial]
% - meassurment: Noisy measurements (observed data)
% - ref_points: Reference (Anchors) points for triangulation
% - R: Measurement noise covariance matrix
% - Q: Process noise covariance matrix
% - dt: Time interval between measurements

% Outputs:
% - Xout: Filtered and smoothed values of the tag's X position
% - Yout: Filtered and smoothed values of the tag's Y position
function [Xout, Yout] = UKF_RTS_smoothing(X0, meassurment, ref_points, R, Q, dt)
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

    % State transition matrix F to update the robot's state
    F = [1, DT, 0, 0;
         0, 1, 0, 0;
         0, 0, 1, DT;
         0, 0, 0, 1];

    % Number of reference points
    N = length(ref_points);

    % Number of iterations (measurements)
    T = size(meassurment, 1);
    timeSteps = 1:T;

    % Smoothing window size (here, a window of size 100)
    windowSize = 100;

    % Smooth noisy measurements using moving average
    meassurment0 = movmean(meassurment, windowSize);

    % Initial state of the robot and state covariance

    % Initialize the UKF filter with parameters alpha, beta, kappa
    alpha = 1;
    beta = 5;
    kappa = 3;

    ukf = unscentedKalmanFilter(@myStateTransitionFcn, @myMeasurementFcn, X0, ...
                               'alpha', alpha, 'beta', beta, 'kappa', kappa);
    ukf.MeasurementNoise = R;
    ukf.ProcessNoise = diag(Q);

    % Variables to store filtered and predicted states
    filteredStates = zeros(N, T);
    predictedStates = zeros(N, T);
    filteredcovs = zeros(N, 4, T);
    predictedCovs = zeros(N, 4, T);

    % Loop over measurements to apply the UKF filter
    for t = 1:T
        % Generate measurements from the true state (with simulated noise added)
        meas = meassurment0(t,:)';

        % UKF Filter: Prediction and Correction
        [predictedState, predictedCov] = ukf.predict();
        predictedStates(:, t) = predictedState; 
        predictedCovs(:, :, t) = predictedCov;
        
        [filteredState, filteredCov] = correct(ukf, meas);
        filteredStates(:, t) = filteredState; 
        filteredcovs(:, :, t) = filteredCov;
    end

    % Apply smoothing using the Rauch-Tung-Striebel (RTS) technique
    SmoothStates = filteredStates;
    SmoothCovs = filteredcovs;

    for t = T - 2 : -1 : 1
        A = filteredcovs(:,:, t) * F' / predictedCovs(:,:, t);  % RTS filter gain
        SmoothStates(:, t) = filteredStates(:, t) + A * (SmoothStates(:, t+1) - predictedStates(:, t+1));  % Smoothed state
        SmoothCovs(:,:, t) = filteredcovs(:,:, t) + A * (SmoothCovs(:,:, t+1) - predictedCovs(:,:, t+1)) * A';  % Smoothed covariance
    end

    % Calculate smoothed measurements (angles) using triangulation
    filterThetas = inv_Triangulation(filteredStates(1,:)', filteredStates(3,:)', ref_points); % shape=(T,N)
    SmoothThetas = inv_Triangulation(SmoothStates(1,:)', SmoothStates(3,:)', ref_points); % shape=(T,N)

    % Plotting results
    % For angles
    % Extract X and Y data
    X = zeros(T, 1);
    Y = zeros(T, 1);
    for t = 1:T 
        [x1, y1] = Triangulation(meassurment(t,:), ref_points);
        X(t,1) = x1;
        Y(t,1) = y1;
    end

    figure;
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
        plot(timeSteps, meassurment(:, i), 'g:','LineWidth',0.5) % Noisy measurements
        plot(timeSteps, filterThetas(:, i), "b--",'LineWidth',1) % Filtered (estimated) measurements
        plot(timeSteps, SmoothThetas(:, i), "r-.",'LineWidth',1.5) % Smoothed measurements
        xlabel('Time Steps');
        ylabel(sprintf('Theta %d (rad)', i));
        title(sprintf('Theta %d (t)', i));
        legend('Error','Estimated',"Smoothed");
        grid on;
    end 

    % For X
    subplot(2,2,2);
    hold on 

    plot(timeSteps, X, 'g:','LineWidth',0.5) % Noisy X measurements
    plot(timeSteps, filteredStates(1, :), "b--",'LineWidth',1) % Filtered X (estimated)
    plot(timeSteps, SmoothStates(1,:), "R-.",'LineWidth',1.5) % Smoothed X measurements
    xlabel('Time Steps');
    ylabel('X Position (m)');
    legend('Error','Estimated',"Smoothed");
    title("X(t)");
    grid on;

    % For Y 
    subplot(2,2,4);
    hold on 
    plot(timeSteps, Y, 'g:','LineWidth',0.5) % Noisy Y measurements
    plot(timeSteps, filteredStates(3, :), "b--",'LineWidth',1) % Filtered Y (estimated)
    plot(timeSteps, SmoothStates(3,:), "r-.",'LineWidth',1.5) % Smoothed Y measurements
    xlabel('Time Steps');
    ylabel('Y Position (m)');
    legend('Error','Estimated',"Smoothed" );
    title("Y(t)");
    grid on;

    % Extract filtered data starting from index 100 to avoid initial unstable values
    Xout = horzcat(X(100:T), filteredStates(1,100:T)', SmoothStates(1,100:T)');
    Yout = horzcat(Y(100:T), filteredStates(3,100:T)', SmoothStates(3,100:T)');
end
