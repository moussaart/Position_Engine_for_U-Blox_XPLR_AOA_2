% Cette fonction implémente le filtre EKF (Extended Kalman Filter) pour 
% estimer la position (X, Y) d'un tag à partir de mesures bruitées.
% Elle effectue également un lissage des données filtrées pour améliorer la précision des estimations.
% Entrées :
% - X0 : état initial du robot (position initiale) [x_initial, vx_initial, y_initial, vy_initial]
% - meassurment : les mesures bruitées (les données observées)
% - ref_points : les points de référence pour la triangulation
% - R : la matrice de covariance du bruit de mesure
% - Q : la matrice de covariance du bruit de processus
% - smooth : paramètres pour le lissage (fenêtre de lissage)
%
% Sorties :
% - Xout : les valeurs filtrées (estimées) de la position X du robot
% - Yout : les valeurs filtrées (estimées) de la position Y du robot
function  [Xout,Yout,mem_used]=EKF(X0,meassurment,ref_points,R,Q,dt,simulation,plot)
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

    % Number of reference points
    N = length(ref_points);

    % Number of iterations (measurements)
    T = size(meassurment, 1);
    meassurment0 =meassurment;

    % Initial state of the robot and state covariance

    ekf = extendedKalmanFilter(@myStateTransitionFcn, @myMeasurementFcn, X0);
    ekf.MeasurementNoise = R;
    ekf.ProcessNoise = diag(Q);

    % Variables to store filtered and predicted states
    filteredStates = zeros(N, T);
    predictedStates = zeros(N, T);
    filteredcovs = zeros(N, 4, T);
    predictedCovs = zeros(N, 4, T);
    X = zeros(T, 1);
    Y = zeros(T, 1);
    Xe = zeros(T, 1);
    Ye = zeros(T, 1);
    f = waitbar(0,'1','Name','Wait...',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');

    setappdata(f,'canceling',0);
    % Loop over measurements to apply the UKF filter
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
        [predictedState, predictedCov] = ekf.predict();
        predictedStates(:, t) = predictedState; 
        predictedCovs(:, :, t) = predictedCov;
        
        [filteredState, filteredCov] = correct(ekf, meas);
        filteredStates(:, t) = filteredState; 
        filteredcovs(:, :, t) = filteredCov;
        waitbar(t/T,f,sprintf('%12.9f %',round(t/T*100,2)));
    end
    delete(f);
    mem_after = memory;
    mem_used = (mem_after.MemUsedMATLAB - mem_before.MemUsedMATLAB)/(1024*T);
    
    % Calculate smoothed measurements (angles) using triangulation
    filterThetas = inv_Triangulation(filteredStates(1,:)', filteredStates(3,:)', ref_points); % shape=(T,N)
    ErrorThetas = inv_Triangulation(Xe, Ye, ref_points); 
    
    if plot==1
    Plotting_results(ErrorThetas,[Xe,Ye], ...
                     filterThetas,filteredStates, ...
                     filterThetas,filteredStates, ...
                     meassurment,[X,Y], ...
                     sqrt(R(1,1)),ref_points,0);
    end

    % Extract filtered data starting from index 100 to avoid initial unstable values
    Xout = horzcat(X(100:T),Xe(100:T), filteredStates(1,100:T)',filteredStates(1,100:T)');
    Yout = horzcat(Y(100:T),Ye(100:T), filteredStates(3,100:T)',filteredStates(1,100:T)');
    

end 