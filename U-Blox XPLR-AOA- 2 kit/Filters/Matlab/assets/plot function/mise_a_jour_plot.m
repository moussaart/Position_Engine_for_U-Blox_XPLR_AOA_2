%{
Function "mise_a_jour_plot"
The "mise_a_jour_plot" function is a MATLAB function that updates the 
displayed data in a real-time graph. It is commonly used when new data
 is continuously generated or acquired, and you want to refresh an existing 
graph to reflect this new data.

Inputs:

x1Window: A vector representing the old data (samples) displayed in the first graph.
x1: A vector containing the new data (samples) to add to the first graph.
x2Window: A vector representing the old data (samples) displayed in the second graph.
x2: A vector containing the new data (samples) to add to the second graph.
hLine1: The handle object of the line associated with the first graph. This
 handle object allows accessing the plotted line
        in the first graph to update its data.
hLine2: The handle object of the line associated with the second graph. This 
        handle object allows accessing the plotted line
        in the second graph to update its data.
timeWindow: A scalar value representing the time window of the data to 
            display in the graph. This value determines the
            time range of the displayed samples.

Outputs:

x1WindowOUT: A vector containing the updated new data for the first graph.
x2WindowOUT: A vector containing the updated new data for the second graph.
%}
function [x1WindowOUT, x2WindowOUT] = mise_a_jour_plot(x1Window, x1, x2Window, x2, hLine1, hLine2, timeWindow)
    % Update sliding windows with new data
    x1WindowOUT = [x1Window(2:end), x1];
    x2WindowOUT = [x2Window(2:end), x2];
    
    % Update data in each subplot
    set(hLine1, 'XData', timeWindow, 'YData', x1WindowOUT);
    set(hLine2, 'XData', timeWindow, 'YData', x2WindowOUT);
end
