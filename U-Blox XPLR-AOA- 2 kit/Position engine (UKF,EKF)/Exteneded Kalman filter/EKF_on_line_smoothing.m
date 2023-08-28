% This function implements the UKF (Extended Kalman Filter) to estimate the
% position (X, Y) of a tag from noisy measurements.
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
function [Xout, Yout, mem_used] = EKF_on_line_smoothing(X0, meassurment, ref_points, R, Q, dt,simulation,plot)
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

    % Smoothing window size (here, a window of size 100)
    windowSize = 100;

    % Smooth noisy measurements using moving average
    meassurment0 = movmean(meassurment, windowSize);

    ekf = extendedKalmanFilter(@myStateTransitionFcn, @myMeasurementFcn, X0);
    ekf.MeasurementNoise = R;
    ekf.ProcessNoise = diag(Q);


    % Initialize matrices to store filtered, predicted, and smoothed states and covariances at each iteration
    filteredStates = zeros(N, T);
    predictedStates = zeros(N, T);
    filteredCovs = zeros(N, 4, T);
    predictedCovs = zeros(N, 4, T);
    SmoothStates = filteredStates;
    SmoothCovs = filteredCovs;
    % Extract X and Y data
    X = zeros(T, 1);
    Y = zeros(T, 1);
    Xe = zeros(T, 1);
    Ye = zeros(T, 1);

    % Main loop to apply EKF filter and perform online smoothing
    f = waitbar(0,'1','Name','Wait...',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');

    setappdata(f,'canceling',0);
    mem_before = memory;
    for t = 1:T
        if getappdata(f,'canceling')
        break
        end
        % Generate measurements from true state (with simulated noise added)
        meas = meassurment0(t,:)';
        [x1, y1] = Triangulation(meas', ref_points);
        X(t,1) = x1;
        Y(t,1) = y1;
        if simulation == 1
        meas = meas + sqrt(R) * randn(4, 1);
        [x1, y1] = Triangulation(meas', ref_points);
        Xe(t,1) = x1;
        Ye(t,1) = y1;
        end

        % Prediction with UKF filter
        [predictedState, predictedCov] = ekf.predict();
        predictedStates(:, t) = predictedState;
        predictedCovs(:, :, t) = predictedCov;

        % Correction with noisy measurements
        [filteredState, filteredCov] = correct(ekf, meas);
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
        waitbar(t/T,f,sprintf('%12.9f %',t/T*100));
    end
    delete(f);
    mem_after = memory;
    mem_used = (mem_after.MemUsedMATLAB - mem_before.MemUsedMATLAB)/(1024*T);
    % Calculate smoothed measurements from filtered states (inverse triangulation)
    filterThetas = inv_Triangulation(filteredStates(1,:)', filteredStates(3,:)', ref_points);
    SmoothThetas = inv_Triangulation(SmoothStates(1,:)', SmoothStates(3,:)', ref_points);
    ErrorThetas = inv_Triangulation(X, Y, ref_points);
    if plot==1
    Plotting_results(ErrorThetas,[Xe,Ye], ...
                     filterThetas,filteredStates, ...
                     SmoothThetas,SmoothStates, ...
                     meassurment,[X,Y], ...
                     sqrt(R(1,1)),ref_points,1);
    end
% Extract filtered data starting from index 100 to avoid initial unstable values
Xout = horzcat(X(100:T),Xe(100:T), filteredStates(1,100:T)', SmoothStates(1,100:T)');
Yout = horzcat(Y(100:T),Ye(100:T), filteredStates(3,100:T)', SmoothStates(3,100:T)');
end



