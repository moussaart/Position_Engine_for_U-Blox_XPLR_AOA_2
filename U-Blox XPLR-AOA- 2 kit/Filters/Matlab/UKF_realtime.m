% Adding path to include external files
run("add_path.m")

% Import configuration parameters
run("Real Time application\setting.m");

% Initialize graphics
run("Real Time application\Initialization_plot.m")

% Hardware connection
run("Real Time application\hardware_connect.m")

try
    % Main program loop (starting from time t=2)
    for t=2:inf
        % Read hardware responses from serial ports s, s2, s3, s4
        response1 = fscanf(s);
        response2 = fscanf(s2);
        response3 = fscanf(s3);
        response4 = fscanf(s4);
        response = {response1, response2, response3, response4};
        % Analyze responses to extract relevant data
        for i = 1:4
            if strncmp(response{i}, '+UUDF', 5)
                if response{i}(6) ~= 'P'
                    list = strsplit(response{i}, ',');
                    if length(list) > 3
                        th(i) = str2double(list{3});
                    end
                end
            end
        end 
        % Check data integrity
        test0 = (th ~= [0, 0, 0, 0]);
        TESTS = [isfinite(th) test0];
        
        % If all conditions are met, perform processing
        if all(TESTS)
            % Convert real angles (th) to theoretical angles (th_work) and radians (th_red)
            th_work = Real2Theorique(th);
            th_red = deg2rad(th_work);
            meas = th_red';
            % Triangulation to obtain coordinates (xe, ye) from measurements 
            % (meas) and reference points (ref_points)
            [xe, ye] = Triangulation(meas, ref_points);
            % Real-time update of Unscented Kalman Filter (UKF) states
            [SmoothState, SmoothCov, Smooth_test] = UKF_real_time_update(ukf, meas, ...
                                                                         F, ...
                                                                         SmoothState, ...
                                                                         SmoothCov, ...
                                                                         smooth_test);

            % Extract estimated coordinates (x_f, y_f) from filtered state (SmoothState)
            x_f = SmoothState(1);
            y_f = SmoothState(3);
            % Update display windows for X and Y plots
            timeWindow = [timeWindow(2:end), t*dt];
            [X_eWindow, X_fWindow] = mise_a_jour_plot(X_eWindow, xe, ...
                                                         X_fWindow, x_f, ...
                                                         X_e, X_f, timeWindow);

            [Y_eWindow, Y_fWindow] = mise_a_jour_plot(Y_eWindow, ye, ...
                                                         Y_fWindow, y_f, ...
                                                         Y_e, Y_f, timeWindow);
            set(plot_XE, 'XData', xe, 'YData', ye);
            set(plot_XF, 'XData', x_f, 'YData', y_f);
            % Real-time display of estimated and filtered positions
            drawnow;
        end
    end
catch ex
    % Error handling: close serial ports and display error information
    fclose(s);
    fclose(s2);
    fclose(s3);
    fclose(s4);
    errorMsg = ['ERROR TYPE: ', ex.message, ' Error at line ', num2str(ex.stack.line), ' in file ', ex.stack.file];
    disp(errorMsg);
end
