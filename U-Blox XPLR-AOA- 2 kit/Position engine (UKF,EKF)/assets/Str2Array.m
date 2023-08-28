% Function Description:
% Str2Array is a MATLAB function that takes a string representation of an array
% and converts it into a numeric array. The input string should have elements
% separated by spaces or commas and be enclosed within square brackets.

function array = Str2Array(str)
    % Remove the opening bracket '[' from the input string
    str = strrep(str, '[', '');

    % Remove the closing bracket ']' from the modified string
    str = strrep(str, ']', '');

    % Convert the modified string to a numeric array
    array = str2num(str);
end