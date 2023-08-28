%{
Function "Initialization_plot"
The "Initialization_plot" function is a MATLAB function used to initialize plot parameters for displaying results
of an analysis, simulation, or any other process that generates graphical data. This function configures subplots
in a figure, sets the overall graph title, and specifies the y-axis (y_lim) value range to enhance data visualization.

Inputs:

subplot: An integer representing the total number of subplots in the figure. This value is used to create an appropriate
        layout of subplots for displaying the results.

maxWindowSize: A pair of integers [width, height] indicating the desired maximum dimensions (width and height)
                for the graphical window. This helps control the size of the generated figure.

title: A string representing the global title of the graph. It will be displayed above all subplots to provide a
       general description of the results.

y_lim: A pair of values [y_min, y_max] indicating the value range of the y-axis (ordinate) for all subplots.
       This allows setting a common scale for better comparison of data between subplots.
%}
function [hLine_e, hLine_f, xeWindow, xfWindow] = Plot0(subplot, maxWindowSize, title, y_lim)
    % Initialize variables
    % Prepare the initial plot
    subplot;

    % Create lines for error and estimation plots
    hLine_e = plot(NaN, NaN, 'b', 'LineWidth', 1);
    hold on;
    hLine_f = plot(NaN, NaN, 'r', 'LineWidth', 2);
    hold off;

    % Label the axes and set legends, grid, and y-axis limits
    xlabel('Time');
    ylabel(title);
    legend('Error', 'Estimated');
    grid on;
    ylim(y_lim);

    % Initialize sliding windows
    % Create two empty arrays of size maxWindowSize to store sliding data.
    xeWindow = zeros(1, maxWindowSize);
    xfWindow = zeros(1, maxWindowSize);
end
