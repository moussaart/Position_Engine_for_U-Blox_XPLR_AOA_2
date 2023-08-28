% Set the maximum window size for real-time plotting
maxWindowSize = 250;

% Create a new figure for the plots
figure;

% Initialize a time window array to store time data for real-time plotting
timeWindow = zeros(1, maxWindowSize);

% Define limits for angle (th_lim) and x, y axes (x_lim and y_lim) for the two subplots
th_lim = [0, pi];
x_lim = [-1, 2];
y_lim = [-3, 3];

% Call the custom function 'Intialization_plot' to create the first subplot (top-left)
[X_e, X_f, X_eWindow, X_fWindow] =Plot0(subplot(2, 2, 1),maxWindowSize, "X en m", x_lim);

% Call the custom function 'Intialization_plot' to create the second subplot (bottom-left)
[Y_e, Y_f, Y_eWindow, Y_fWindow] = Plot0(subplot(2, 2, 3), maxWindowSize, "Y en m", y_lim);

% Select the third subplot (top-right)
subplot(1, 2, 2);

% Set the axis limits for the third subplot
axis([-0.1 0.7 -0.1 2]);

% Enable 'hold on' to overlay multiple plots on the same axes
hold on;

% Loop through 'ref_points' to plot each point with an annotation
for i = 1:size(ref_points, 1)
    x_i = ref_points(i, 1);
    y_i = ref_points(i, 2);
    
    % Plot the point as a yellow scatter plot with a label, e.g., 'R1', 'R2', ...
    scatter(x_i, y_i, 100, 'filled', 'MarkerFaceColor', 'yellow');
    text(x_i + 0.1, y_i + 0.1, ['R', num2str(i)]);
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