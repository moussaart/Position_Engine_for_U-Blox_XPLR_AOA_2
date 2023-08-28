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
function [Xout, Yout, mem_used] = EKF_RTS_smoothing(X0, meassurment, ref_points, R, Q, dt,simulation,plot)
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


    % Smooth noisy measurements using moving average
    meassurment0 = meassurment;

    % Initial state of the robot and state covariance


    ukf =extendedKalmanFilter(@myStateTransitionFcn, @myMeasurementFcn, X0);
    ukf.MeasurementNoise = R;
    ukf.ProcessNoise = diag(Q);

    % Variables to store filtered and predicted states
    filteredStates = zeros(N, T);
    predictedStates = zeros(N, T);
    filteredcovs = zeros(N, 4, T);
    predictedCovs = zeros(N, 4, T);
    X = zeros(T, 1);
    Y = zeros(T, 1);
    Xe = zeros(T, 1);
    Ye = zeros(T, 1);
    % Loop over measurements to apply the UKF filter
    f = waitbar(0,'1','Name','Wait..',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');

    setappdata(f,'canceling',0);
    mem_before = memory;
    for t = 1:T
        if getappdata(f,'canceling')
        break
        end
        % Generate measurements from the true state (with simulated noise added)
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

        % UKF Filter: Prediction and Correction
        [predictedState, predictedCov] = ukf.predict();
        predictedStates(:, t) = predictedState; 
        predictedCovs(:, :, t) = predictedCov;
        
        [filteredState, filteredCov] = correct(ukf, meas);
        filteredStates(:, t) = filteredState; 
        filteredcovs(:, :, t) = filteredCov;
        waitbar(t/T,f,sprintf('%12.9f %',t/T*100));
    end
    delete(f);

    % Apply smoothing using the Rauch-Tung-Striebel (RTS) technique
    SmoothStates = filteredStates;
    SmoothCovs = filteredcovs;

    for t = T - 2 : -1 : 1
        A = filteredcovs(:,:, t) * F' / predictedCovs(:,:, t);  % RTS filter gain
        SmoothStates(:, t) = filteredStates(:, t) + A * (SmoothStates(:, t+1) - predictedStates(:, t+1));  % Smoothed state
        SmoothCovs(:,:, t) = filteredcovs(:,:, t) + A * (SmoothCovs(:,:, t+1) - predictedCovs(:,:, t+1)) * A';  % Smoothed covariance
    end
    mem_after = memory;
    mem_used = (mem_after.MemUsedMATLAB - mem_before.MemUsedMATLAB)/(1024*T);

    % Calculate smoothed measurements (angles) using triangulation
    filterThetas = inv_Triangulation(filteredStates(1,:)', filteredStates(3,:)', ref_points); % shape=(T,N)
    SmoothThetas = inv_Triangulation(SmoothStates(1,:)', SmoothStates(3,:)', ref_points); % shape=(T,N)
    ErrorThetas = inv_Triangulation(Xe, Ye, ref_points); 

    % Plotting results
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
