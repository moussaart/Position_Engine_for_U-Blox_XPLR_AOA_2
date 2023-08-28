% Function Description:
% Plotting_results_barr is a MATLAB function that generates bar plots to
% visualize and compare the performance of two filtering methods (UKF and EKF)
% with respect to position estimation errors, variances, and memory usage.

function Plotting_results_barr(Xout_ukf, Yout_ukf, Xout_ekf, Yout_ekf, mem)
    % Define RGB colors for the bar plots
    color1 = [144, 12, 63] / 255;   % RGB triplet
    color2 = [199, 0, 57] / 255;    % RGB triplet
    color3 = [249, 76, 16] / 255;   % RGB triplet
    color4 = [248, 222, 34] / 255;  % RGB triplet
    color5 = [206, 206, 90] / 255;  % RGB triplet
    color6 = [255, 225, 123] / 255; % RGB triplet
    color7 = [253, 141, 20] / 255;  % RGB triplet

    % Initialize arrays to store results
    X_ukf = [Xout_ukf(:, 2), Xout_ukf(:, 4)];
    X = [Xout_ukf(:, 1), Xout_ukf(:, 1)];
    Y_ukf = [Yout_ukf(:, 2), Yout_ukf(:, 4)];
    Y = [Yout_ukf(:, 1), Yout_ukf(:, 1)];

    % Calculate UKF position estimation errors and variances
    UKF_x_erreur = mean(abs(X - X_ukf), 1);
    UKF_x_var = std(abs(X - X_ukf), 1);
    UKF_y_erreur = mean(abs(Y - Y_ukf), 1);
    UKF_y_var = std(abs(Y - Y_ukf), 1);

    X_ekf = [Xout_ekf(:, 2), Xout_ekf(:, 4)];
    X_s_ekf = [Xout_ekf(:, 1), Xout_ekf(:, 1)];
    Y_ekf = [Yout_ekf(:, 2), Yout_ekf(:, 4)];
    Y_s_ekf = [Yout_ekf(:, 1), Yout_ekf(:, 1)];

    % Calculate EKF position estimation errors and variances
    EKF_x_erreur = mean(abs(X_s_ekf - X_ekf), 1);
    EKF_x_var = std(abs(X_s_ekf - X_ekf), 1);
    EKF_y_erreur = mean(abs(Y_s_ekf - Y_ekf), 1);
    EKF_y_var = std(abs(Y_s_ekf - Y_ekf), 1);

    % Calculate overall position errors and variances
    X_error = [mean([UKF_x_erreur(1, 1) EKF_x_erreur(1, 1)]) UKF_x_erreur(1, 2) EKF_x_erreur(1, 2)];
    Y_error = [mean([UKF_y_var(1, 1) EKF_y_var(1, 1)]) UKF_y_erreur(1, 2) EKF_y_erreur(1, 2)];
    P_error = mean([X_error; Y_error], 1);

    X_var = [mean([UKF_x_var(1, 1) EKF_x_var(1, 1)]) UKF_x_var(1, 2) EKF_x_var(1, 2)];
    Y_var = [mean([UKF_y_var(1, 1) EKF_y_var(1, 1)]) UKF_y_var(1, 2) EKF_y_var(1, 2)];
    P_var = mean([X_var; Y_var], 1);

    % Define categorical labels for the bar plots
    list_sigma_error = categorical({'Without Filter', 'UKF', 'EKF'});
    list_sigma_error = reordercats(list_sigma_error, {'Without Filter', 'UKF', 'EKF'});

    % Create a figure to display the results
    figure;

    % Plot the first subplot (Mean X Position Error)
    subplot(2, 4, 1);
    hold on;
    bar(list_sigma_error, X_error, 'FaceColor', color1);
    ylabel("Mean X Error (m)");
    xlabel("Filter Type");
    grid on;

    % Plot the second subplot (X Position Variance)
    subplot(2, 4, 2);
    hold on;
    bar(list_sigma_error, X_var, 'FaceColor', color2);
    ylabel("X Variance (m^2)");
    xlabel("Filter Type");
    grid on;

    % Plot the third subplot (Mean Y Position Error)
    subplot(2, 4, 5);
    hold on;
    bar(list_sigma_error, Y_error, 'FaceColor', color3);
    ylabel("Mean Y Error (m)");
    xlabel("Filter Type");
    grid on;

    % Plot the fourth subplot (Y Position Variance)
    subplot(2, 4, 6);
    hold on;
    bar(list_sigma_error, Y_var, 'FaceColor', color4);
    ylabel("Y Variance (m^2)");
    xlabel("Filter Type");
    grid on;

    % Plot the fifth subplot (Mean Position Error)
    subplot(2, 4, 3);
    hold on;
    bar(list_sigma_error, P_error, 'FaceColor', color5);
    ylabel("Mean Position Error (m)");
    xlabel("Filter Type");
    grid on;

    % Plot the sixth subplot (Position Variance)
    subplot(2, 4, 7);
    hold on;
    bar(list_sigma_error, P_var, 'FaceColor', color6);
    ylabel("Position Variance (m^2)");
    xlabel("Filter Type");
    grid on;

    % Plot the seventh subplot (Memory Usage)
    subplot(1, 4, 4);
    hold on;
    bar(list_sigma_error(2:3), mem, 'FaceColor', color7);
    ylabel("Memory Usage per Iteration (KB)");
    xlabel("Filter Type");
    grid on;
end
