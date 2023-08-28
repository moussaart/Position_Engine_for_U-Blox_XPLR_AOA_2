% Cette fonction implémente le filtre UKF (Unscented Kalman Filter) pour 
% estimer la position (X, Y) d'un tag à partir de mesures bruitées.
% Elle effectue également un lissage des données filtrées pour améliorer la précision des estimations.
% Entrées :
% - X0 : état initial du robot (position initiale) [x_initial, vx_initial, y_initial, vy_initial]
% - meassurment : les mesures bruitées (les données observées)
% - ref_points : les points de référence pour la triangulation
% - R : la matrice de covariance du bruit de mesure
% - Q : la matrice de covariance du bruit de processus
% - smooth : paramètres pour le lissage (fenêtre de lissage)
%
% Sorties :
% - Xout : les valeurs filtrées (estimées) de la position X du robot
% - Yout : les valeurs filtrées (estimées) de la position Y du robot
function  [Xout,Yout]=UKF(X0,meassurment,ref_points,R,Q,simulation)

% Extraction des dimensions du problème
measurement0 = meassurment;
N = length(ref_points);
T = size(meassurment, 1); % Nombre d'itérations (mesures)
timeSteps = 1:T;


% Initialisation du filtre UKF avec les paramètres spécifiés
alpha = 1;
beta = 5;
kappa = 3;

ukf = unscentedKalmanFilter(@transitionFcn, @measurementFcn, X0, ...
                           'alpha', alpha, 'beta', beta, 'kappa', kappa);
ukf.MeasurementNoise = R;
ukf.ProcessNoise = diag(Q);

% Initialisation de la matrice pour stocker les états filtrés à chaque itération
filteredStates = zeros(N, T);
meassurmentE=zeros(T,N);
% Boucle principale pour appliquer le filtre UKF et effectuer le lissage
for t = 1:T
    % Générer les mesures bruitées à partir de l'état réel (avec ajout de bruit simulé)

    % Mesure bruitée au temps t
    meas = measurement0(t,:)';
    
    if simulation == 1
        meas = meas + sqrt(R) * randn(4, 1);
        meassurmentE(t,:)=meas';
    else 
        meassurmentE(t,:)=meas';
    end

    % Prédiction et correction avec le filtre UKF
    ukf.predict();
    [filteredState, filteredCov] = correct(ukf, meas);
    
    % Stocker l'état filtré à l'itération t
    filteredStates(:, t) = filteredState; 
end

% Calcul des mesures filtrées à partir des états filtrés (triangulation inverse)
filterThetas = inv_Triangulation(filteredStates(1,:)', filteredStates(3,:)', ref_points);

% Tracage des résultats
% Extract X and Y data
X = zeros(T, 2);
Y = zeros(T, 2);
for t = 1:T 
    [x1, y1] = Triangulation(meassurment(t,:), ref_points);
    [xe, ye] = Triangulation(meassurmentE(t,:), ref_points);
    X(t,1) = x1;
    Y(t,1) = y1;
    X(t,2) = xe;
    Y(t,2) = ye;
end

% Tracer les valeurs estimées (filtrées) et les erreurs pour chaque angle
figure;
orange = [255/255, 165/255, 0/255];
for i = 1:N  
    switch i
        case 1
            subplot(2, 4, 1);
        case 2 
            subplot(2, 4, 2);
        case 3 
            subplot(2, 4, 5);
        case 4
            subplot(2, 4, 6);
    end 

    hold on 
    
    plot(timeSteps, meassurmentE(:, i), 'g:','LineWidth',0.5) % Mesures bruitées
    plot(timeSteps, filterThetas(:, i), "b--",'LineWidth',1) % Mesures filtrées (estimées)
    plot(timeSteps, meassurment(:, i), 'r','LineWidth',1.5) % sans bruitées
    xlabel('Time Steps');
    ylabel(sprintf('Theta %d (rad)', i));
    title(sprintf('Theta %d (t)', i));
    legend('Error','Estimated', 'Without noise' );
    
    grid on;
end 
 
% Tracer les valeurs estimées (filtrées) de la position X et les erreurs
subplot(2, 2, 2);
hold on 
plot(timeSteps, X(:,2), 'g:','LineWidth',0.5) % X bruité (Mesures bruitées)
plot(timeSteps, filteredStates(1, :), "b--",'LineWidth',1) % X filtré (estimé)
plot(timeSteps, X(:,1), 'r','LineWidth',1.5) % X réel (mesuré)
xlabel('Time Steps');
ylabel('X Position (m)');
legend('Error','Estimated', 'Without noise' );
title('Plot en temps réel');
grid on;

% Tracer les valeurs estimées (filtrées) de la position Y et les erreurs
subplot(2, 2, 4);
hold on 
plot(timeSteps, Y(:,2), 'g:','LineWidth',0.5) % X bruité (Mesures bruitées)
plot(timeSteps, filteredStates(3, :), 'b--','LineWidth',1) % X filtré (estimé)
plot(timeSteps, Y(:,1), 'r','LineWidth',1.5) % X réel (mesuré)
xlabel('Time Steps');
ylabel('Y Position (m)');
legend('Error','Estimated', 'Without noise' );
title('Plot en temps réel');

% Préparation des sorties Xout et Yout pour la suite
Xout = horzcat(X(100:T,1), filteredStates(1, 100:T)');
Yout = horzcat(Y(100:T,1), filteredStates(3, 100:T)');

end 