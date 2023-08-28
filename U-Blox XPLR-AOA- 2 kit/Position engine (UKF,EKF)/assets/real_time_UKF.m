% Function Description:
% real_time_UKF is a MATLAB function for real-time processing of sensor data
% from multiple serial ports and updating position estimates using Unscented
% Kalman Filtering (UKF) techniques.

function real_time_UKF(port, port1 ,port2 ,port3,x0,Q,X_anchor,Y_anchor,orientation,sigma_theta)

% Define reference points (anchors) as a matrix [x, y]
ref_points = [0 0; X_anchor 0; X_anchor Y_anchor; 0 Y_anchor];

% Sampling frequency (number of samples per second)

f=1000;
% Time Step (time duration between two consecutive samples)
dt = 1 / f;

% Initialization of the Extended Kalman Filter (EKF) with custom parameters


% State transition matrix F (4x4) to propagate the state from time step t to t+1
F = [1 dt 0 0;
     0 1  0 0;
     0 0  1 dt;
     0 0  0 1];
% Initialize the UKF filter with parameters alpha, beta, kappa
    alpha = 1;
    beta = 7;
    kappa = 3;
% Create an Unscented Kalman Filter object (ukf) using custom transitionFcn and measurementFcn
ukf = Inititaliztion_filter_UKF(x0,alpha,beta,kappa,sigma_theta,Q,ref_points,dt);

% Initialize some variables (not clear from the provided code what they are used for)
SmoothState = zeros(4, 1);
SmoothCov = zeros(4);
smooth_test = 0;
% Set the maximum window size for real-time plotting
maxWindowSize = 250;

% Create a new figure for the plots
figure;

% Initialize a time window array to store time data for real-time plotting
timeWindow = zeros(1, maxWindowSize);

% Define limits for angle (th_lim) and x, y axes (x_lim and y_lim) for the two subplots
x_lim = [-1, 2];
y_lim = [-3, 3];

% Call the custom function 'Intialization_plot' to create the first subplot (top-left)
[X_e, X_f, X_eWindow, X_fWindow] =Plot0(subplot(2, 2, 1),maxWindowSize, "X en m",'Estimated:EKF', x_lim);

% Call the custom function 'Intialization_plot' to create the second subplot (bottom-left)
[Y_e, Y_f, Y_eWindow, Y_fWindow] = Plot0(subplot(2, 2, 3), maxWindowSize, "Y en m",'Estimated:EKF', y_lim);

% Select the third subplot (top-right)
subplot(1, 2, 2);

% Set the axis limits for the third subplot
axis([-X_anchor*0.2, X_anchor*(1.2), -Y_anchor*0.2, Y_anchor*1.2]);
ports={port, port1 ,port2 ,port3};
% Enable 'hold on' to overlay multiple plots on the same axes
hold on;
% Loop through 'ref_points' to plot each point with an annotation
for i = 1:size(ref_points, 1)
    x_i = ref_points(i, 1);
    y_i = ref_points(i, 2);
    dx=(X_anchor)*cos(deg2rad(orientation(i)))/5;
    dy=(Y_anchor)*sin(deg2rad(orientation(i)))/5;
    % Plot the point as a yellow scatter plot with a label, e.g., 'R1', 'R2', ...
    scatter( x_i, y_i, 100, ...
                    'filled', ...
                    'MarkerFaceColor', 'yellow', ...
                    'LineWidth', 3);
    text(x_i+0.1, y_i+0.1, sprintf('R%d:%s', i, ports{i}));
    quiver(x_i, y_i, ...
           dx, dy, 0, 'LineWidth', 2, 'MaxHeadSize', 0.5);
    
end

% Initialize 'plot_XE' with a blue point
plot_XE = plot(0, 0, 'bo');

% Initialize 'plot_XF' with a red point
plot_XF = plot(0, 0, 'ro');

% Set labels for x and y axes
xlabel('X');
ylabel('Y');

% Set the title for the third subplot
title('Real-Time Point Plotting');

% Enable grid lines on the third subplot
grid on;
% Set the following parameters with values specific to your hardware
% Serial port on Windows or '/dev/ttyUSBx' on Linux/Mac
baudrate = 1000000; % Communication speed in bauds
dataBits = 8;
stopBits = 1;
parity = 'none';

% Open the serial connections
s  = serial(port, 'BaudRate', baudrate, 'DataBits', dataBits, 'StopBits', stopBits, 'Parity', parity);
s2 = serial(port1, 'BaudRate', baudrate, 'DataBits', dataBits, 'StopBits', stopBits, 'Parity', parity);
s3 = serial(port2, 'BaudRate', baudrate, 'DataBits', dataBits, 'StopBits', stopBits, 'Parity', parity);
s4 = serial(port3, 'BaudRate', baudrate, 'DataBits', dataBits, 'StopBits', stopBits, 'Parity', parity);



% Initialize theta (angles) to zeros
th = [0, 0, 0, 0];
try 
      % Main program loop (starting from time t=2)
        % Open the serial connections
        fopen(s);
        fopen(s2);
        fopen(s3);
        fopen(s4);
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
                th_work = Real2Theorique(th,orientation);
                th_red = deg2rad(th_work);
                meas = th_red';
                % Triangulation to obtain coordinates (xe, ye) from measurements 
                % (meas) and reference points (ref_points)
                [xe, ye] = Triangulation(meas, ref_points);
                % Real-time update of Extended Kalman Filter (EKF) states
                [SmoothState, SmoothCov, smooth_test] = EKF_real_time_update(ukf, meas, ...
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
    fclose(s);
    fclose(s2);
    fclose(s3);
    fclose(s4);
end


end