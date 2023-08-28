% filter_Algorithm_Selector: Filtering Algorithm Dispatcher
% This function coordinates the execution of different real-time filtering
% algorithms based on the selected filter type. It extracts necessary
% parameters from the app object and directs the flow of execution to
% appropriate functions.

function filter_Algorithm_Selector(app)
    % Extracting port values from app
    port = app.port1;
    port1 = app.port2;
    port2 = app.port3; 
    port3 = app.port4;
    
    % Converting initial state and Q matrix from strings to arrays
    x0 = Str2Array(app.x_0)';
    Q = Str2Array(app.Q);
    
    % Extracting anchor coordinates, orientation, and other parameters from app
    X_anchor = app.X_anchor;
    Y_anchor = app.Y_anchor;
    orientation = app.orientation;
    sigma_theta = app.sigma_theta;
    filter_type = app.filter_type;
    
    % Performing different actions based on the selected filter type
    switch filter_type
        case "Unscented Kalman filter"
            % Calling the real-time Unscented Kalman filter function
            real_time_UKF(port, port1, port2, port3, ...
                          x0, Q, X_anchor, Y_anchor, ...
                          orientation, sigma_theta);
        case "Extended Kalman filter"
            % Calling the real-time Extended Kalman filter function
            real_time_EKF(port, port1, port2, port3, ...
                          x0, Q, X_anchor, Y_anchor, ...
                          orientation, sigma_theta);
        case "Comparison between the two filters"
            % Calling the real-time comparison function between the filters
            real_time_Com(port, port1, port2, port3, ...
                          x0, Q, X_anchor, Y_anchor, ...
                          orientation, sigma_theta);
    end
end