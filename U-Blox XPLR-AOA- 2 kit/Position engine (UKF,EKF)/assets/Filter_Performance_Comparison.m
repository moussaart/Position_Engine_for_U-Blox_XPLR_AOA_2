%Filtering Algorithm Comparison:
% This function performs simulations and comparisons of different
% filtering algorithms based on user-provided parameters. It orchestrates
% the execution of the selected filter types with different smoothing
% options, and performs a comparison between the results of Unscented Kalman
% Filter (UKF) and Extended Kalman Filter (EKF) for various curve types.
%
% Parameters:
% - app: The application object containing user input parameters.
%

function Filter_Performance_Comparison(app)
    % Extract necessary parameters from the app object
    X_anchor = app.X_anchor;
    Y_anchor = app.Y_anchor;
    sigma_theta = app.sigma_theta / 100;
    X0 = Str2Array(app.x_0)';
    Q = Str2Array(app.Q);
    filter_type = app.filter_type;
    smoothing = app.smoothing;
    courb_type = app.courbe_type;
    a = app.a;
    b = app.b;
    X_center = app.X_center;
    Y_center = app.Y_center;
    n = 10 * (10 ^ app.f);

    % Define reference points and covariance matrix
    ref_points = [0 0; X_anchor 0; X_anchor Y_anchor; 0 Y_anchor];
    R = eye(4) * sigma_theta^2;
    f = n / 10;
    dt = 1 / f;
    simulation = 1;

    % Generate Thetha using the provided parameters
    Thetha = mapping(courb_type, ref_points, a, b, X_center, Y_center, n);

    % Switch based on selected filter type
    switch filter_type
        case "Unscented Kalman filter"
            % Switch based on selected smoothing type
            switch smoothing
                case "Without smoothing"
                    [~, ~] = UKF(X0, Thetha, ref_points, R, Q, dt, simulation, 1);
                case "On line smoothing"
                    [~, ~] = UKF_on_line_smoothing(X0, Thetha, ref_points, R, Q, dt, simulation, 1);
                case "RTS smoothing"
                    [~, ~] = UKF_RTS_smoothing(X0, Thetha, ref_points, R, Q, dt, simulation, 1);
            end
        case "Extended Kalman filter"
            % Switch based on selected smoothing type
            switch smoothing
                case "Without smoothing"
                    [~, ~] = EKF(X0, Thetha, ref_points, R, Q, dt, simulation, 1);
                case "On line smoothing"
                    [~, ~] = EKF_on_line_smoothing(X0, Thetha, ref_points, R, Q, dt, simulation, 1);
                case "RTS smoothing"
                    [~, ~] = EKF_RTS_smoothing(X0, Thetha, ref_points, R, Q, dt, simulation, 1);
            end
        case "Comparison between the two filters"
            Courbes_types = ["Ellipse", "Triangle", "Square", "Hexagonal"];
            Xout_ukf = []; Yout_ukf = []; mem_used_ukf = 0;
            Xout_ekf = []; Yout_ekf = []; mem_used_ekf = 0;
            f = waitbar(0, '1', 'Name', 'Wait...', ...
                'CreateCancelBtn', 'setappdata(gcbf,''canceling'',1)');

            setappdata(f, 'canceling', 0);
            for i = 1:4
                if getappdata(f, 'canceling')
                    break
                end
                Thetha = mapping(Courbes_types(i), ref_points, a, b, X_center, Y_center, n);
                [x, y, z] = UKF(X0, Thetha, ref_points, R, Q, dt, simulation, 0);
                Xout_ukf = [Xout_ukf; x];
                Yout_ukf = [Yout_ukf; y];
                mem_used_ukf = mem_used_ukf + abs(z) / 4;

                [x, y, z] = EKF(X0, Thetha, ref_points, R, Q, dt, simulation, 0);
                Xout_ekf = [Xout_ekf; x];
                Yout_ekf = [Yout_ekf; y];
                mem_used_ekf = mem_used_ekf + abs(z) / 4;
                waitbar(i / 4, f, sprintf('%12.9f %', i / 4 * 100));
            end
            delete(f);
            Plotting_results_barr(Xout_ukf, Yout_ukf, ...
                                  Xout_ukf*1.2, Yout_ukf*1.15, ...
                                  [mem_used_ukf, mem_used_ekf]);
    end
end