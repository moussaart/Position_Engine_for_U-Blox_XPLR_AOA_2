% This function implements the UKF (Unscented Kalman Filter) to estimate the position (X, Y) of a tag from noisy measurements.
% It also performs online smoothing of the filtered data using the online smoothing technique.

% Inputs:
% - X0: Initial state of the robot (initial position) [x_initial, vx_initial, y_initial, vy_initial]
% - meassurment: Noisy measurements (observed data)
% - ref_points: Reference points for triangulation
% - R: Measurement noise covariance matrix
% - Q: Process noise covariance matrix
% - dt: Time interval between measurements

% Outputs:
% - Xout: Filtered (estimated) values of the robot's X position (with online smoothing)
% - Yout: Filtered (estimated) values of the robot's Y position (with online smoothing)
function [Xout, Yout] = UKF_on_line_smoothing(X0, meassurment, ref_points, R, Q, dt)
    % Define the state transition matrix F for the state model
    DT = dt;

    % Nested function definition for state transition
    function XK = myStateTransitionFcn(x)
        XK = transitionFcn(x, DT);
    end

    % Nested function definition for measurement
    function z = myMeasurementFcn(xk)
        z = measurementFcn(xk, ref_points);
    end

    % State transition matrix F
    F = [1, DT, 0, 0;
         0, 1, 0, 0;
         0, 0, 1, DT;
         0, 0, 0, 1];

    % Extract dimensions of the problem
    N = length(ref_points);
    T = size(meassurment, 1); % Number of iterations (measurements)
    timeSteps = 1:T;

    % Smoothing window size (here, a window of size 100)
    windowSize = 100;

    % Smooth noisy measurements using moving average
    measurement0 = movmean(meassurment, windowSize);

    % Initialize UKF filter with specified parameters
    alpha = 1;
    beta = 5;
    kappa = 3;

    ukf = unscentedKalmanFilter(@myStateTransitionFcn, @myMeasurementFcn, X0, ...
                               'alpha', alpha, 'beta', beta, 'kappa', kappa);
    ukf.MeasurementNoise = R;
    ukf.ProcessNoise = diag(Q);

    % Calculate smoothing window size for online smoothing
    windowSize2 = round((T - 1) / 2);

    % Initialize matrices to store filtered, predicted, and smoothed states and covariances at each iteration
    filteredStates = zeros(N, T);
    predictedStates = zeros(N, T);
    filteredCovs = zeros(N, 4, T);
    predictedCovs = zeros(N, 4, T);
    SmoothStates = filteredStates;
    SmoothCovs = filteredCovs;

    % Main loop to apply UKF filter and perform online smoothing
    for t = 1:T
        % Generate measurements from true state (with simulated noise added)
        meas = measurement0(t,:)';

        % Prediction with UKF filter
        [predictedState, predictedCov] = ukf.predict();
        predictedStates(:, t) = predictedState;
        predictedCovs(:, :, t) = predictedCov;

        % Correction with noisy measurements
        [filteredState, filteredCov] = correct(ukf, meas);
        filteredStates(:, t) = filteredState;
        filteredCovs(:, :, t) = filteredCov;
        SmoothStates(:, t) = filteredState;
        SmoothCovs(:, :, t) = filteredCov;

        % Online smoothing: update smoothed state at every  iterations
        if t ~= 1
            % If the update index (i) is not zero, it means we are in the case of smoothed update.
            
            % Calculate smoothing gain A
            A =  filteredCovs(:, :, t-1) * F' / predictedCovs(:, :, t-1);

            % Update smoothed filtered state using smoothing gain A
            SmoothStates(:,t-1) = filteredStates(:, t-1) + A * (SmoothStates(:,t) - predictedState);

            % Update smoothed filtered covariance using smoothing gain A
            SmoothCovs(:, :, t-1) = filteredCovs(:, :, t-1) + A * (SmoothCovs(:, :, t) - predictedCov) * A';
        end
    end

    % Calculate smoothed measurements from filtered states (inverse triangulation)
    filterThetas = inv_Triangulation(filteredStates(1,:)', filteredStates(3,:)', ref_points);
    SmoothThetas = inv_Triangulation(SmoothStates(1,:)', SmoothStates(3,:)', ref_points);

    % Plotting results
    % Extract X and Y data
    X = zeros(T, 1);
    Y = zeros(T, 1);
    for t = 1:T 
        [xe, ye] = Triangulation(meassurment(t,:), ref_points);
        X(t) = xe;
        Y(t) = ye;
    end
    % Tracer les valeurs estimées (filtrées) et les erreurs pour chaque angle
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
        plot(timeSteps, meassurment(:, i), 'g:','LineWidth',0.5) % Mesures bruitées
        plot(timeSteps, filterThetas(:, i), "b--",'LineWidth',1) % Mesures filtrées (estimées)
        plot(timeSteps, SmoothThetas(:, i), "r-.",'LineWidth',1.5) % Mesures lissées
        xlabel('Time Steps');
        ylabel(sprintf('Theta %d (rad)', i));
        title(sprintf('Theta %d (t)', i));
        legend('Error','Estimated',"Smoothed");
        grid on;
    end 
    
    % Pour X
    subplot(2,2,2);
    hold on 
    
    plot(timeSteps, X, 'g:','LineWidth',0.5) % X bruité (Mesures bruitées)
    plot(timeSteps, filteredStates(1, :), "b--",'LineWidth',1) % X filtré (estimé)
    plot(timeSteps, SmoothStates(1,:), "R-.",'LineWidth',1.5) % Mesures lissées
    xlabel('Time Steps');
    ylabel('X Position (m)');
    legend('Error','Estimated',"Smoothed");
    
    grid on;
    
    % Pour Y 
    subplot(2,2,4);
    hold on 
    plot(timeSteps, Y, 'g:','LineWidth',0.5) % X bruité (Mesures bruitées)
    plot(timeSteps, filteredStates(3, :), "b--",'LineWidth',1) % X filtré (estimé)
    plot(timeSteps, SmoothStates(3,:), "r-.",'LineWidth',1.5) % Mesures lissées
    xlabel('Time Steps');
    ylabel('Y Position (m)');
    legend('Error','Estimated',"Smoothed" );
    grid on;

    % Extract filtered data starting from index 100 to avoid initial unstable values
    Xout = horzcat(X(100:T), filteredStates(1,100:T)', SmoothStates(1,100:T)');
    Yout = horzcat(Y(100:T), filteredStates(3,100:T)', SmoothStates(3,100:T)');
end



