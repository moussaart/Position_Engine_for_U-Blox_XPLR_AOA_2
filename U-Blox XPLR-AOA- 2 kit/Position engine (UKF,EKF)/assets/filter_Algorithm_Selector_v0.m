% real_time - Real-time Filtering Algorithm Dispatcher
% This function coordinates the execution of different real-time filtering
% algorithms based on the selected filter type. It extracts necessary
% parameters from the app object and directs the flow of execution to
% appropriate functions.

function filter_Algorithm_Selector_v0(port, port1, port2,port3,x0,Q,X_anchor,Y_anchor,orientation,sigma_theta,filter_type)
    
    
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