% Load the settings from the file "setting.m"
run("setting.m")

% Get the length of the list_sigma_error
INDEX = length(list_sigma_error);

% Set X_tag and Y_tag values
X_tag = 0.35;
Y_tag = 0.7;

% Initialize arrays to store results
X_error = zeros(INDEX, 3);
Y_error = zeros(INDEX, 3);
X_var = zeros(INDEX, 3);
Y_var = zeros(INDEX, 3);

% Loop over each index in the list_sigma_error
for index = 1:INDEX
    R = eye(4) * list_sigma_error(index)^2;
    
    % Call the UKF_smooth function with some parameters
    [Xout, Yout] = UKF_RTS_smoothing(x0, Thetha, ref_points, R, Q);
    
    % Calculate mean errors for X and Y
    X_error(index, :) = mean(abs(X_tag * ones(size(Xout)) - Xout), 1);
    Y_error(index, :) = mean(abs(Y_tag * ones(size(Yout)) - Yout), 1);
    
    % Calculate standard deviation for X and Y
    X_var(index, :) = std(abs(X_tag * ones(size(Xout)) - Xout), 1);
    Y_var(index, :) = std(abs(Y_tag * ones(size(Yout)) - Yout), 1);
end 

% Create a figure to display the results
figure;

% Plot the first subplot
subplot(2, 2, 1);
hold on;
bar(list_sigma_error, X_error);
ylabel("Erreur moyenne de X en m");
xlabel("Ecart type des mesures en rad");
legend('error', 'Estimated', "Smoothed");
grid on;

% Plot the second subplot
subplot(2, 2, 2);
hold on;
bar(list_sigma_error, X_var);
ylabel("Ecart type de X en m");
xlabel("Ecart type des mesures en rad");
legend('error', 'Estimated', "Smoothed");
grid on;

% Plot the third subplot
subplot(2, 2, 3);
hold on;
bar(list_sigma_error, Y_error);
ylabel("Erreur moyenne Y en m");
xlabel("Ecart type des mesures en rad");
legend('error', 'Estimated', "Smoothed");
grid on;

% Plot the fourth subplot
subplot(2, 2, 4);
hold on;
bar(list_sigma_error, Y_var);
ylabel("Ecart type de Y en m");
xlabel("Ecart type des mesures en rad");
legend('error', 'Estimated', "Smoothed");
grid on;

