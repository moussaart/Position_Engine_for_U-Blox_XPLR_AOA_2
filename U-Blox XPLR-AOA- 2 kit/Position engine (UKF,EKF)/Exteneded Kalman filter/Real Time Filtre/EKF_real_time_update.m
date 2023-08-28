% Cette fonction met à jour l'état et la covariance filtrés en temps réel à l'aide du filtre UKF (Unscented Kalman Filter).
% Entrées :
% - ukf : objet UKF initialisé avec les paramètres appropriés
% - meas : vecteur de mesures réelles (mesurées) au temps actuel
% - F : matrice de transformation entre les états prédits et filtrés
% - SmoothState : état filtré lissé (en sortie de cette fonction, contiendra l'état filtré lissé mis à jour)
% - SmoothCov : covariance filtrée lissée (en sortie de cette fonction, contiendra la covariance filtrée lissée mise à jour)
% - i : indice de mise à jour (0 ou 1, voir ci-dessous)
%
% Sorties :
% - SmoothStateOut : nouvel état filtré lissé mis à jour
% - SmoothCovOut : nouvelle covariance filtrée lissée mise à jour
% - Iout : nouvel indice de mise à jour (0 ou 1, voir ci-dessous)

function [SmoothStateOut,SmoothCovOut,Iout] = EKF_real_time_update(ekf,meas,F,SmoothState,SmoothCov,i)
% Prédiction de l'état et de la covariance avec le filtre EKF
[predictedState, predictedCov] = ekf.predict();

% Correction de l'état et de la covariance avec la mesure réelle actuelle
[filteredState, filteredCov] = correct(ekf, meas);  % X=[x, vx, y, vy], size(P) = (Size(X), Size(X))

% Mise à jour lissée en fonction de l'indice de mise à jour (i)
if i ~= 0 
    % Si l'indice de mise à jour (i) est différent de zéro, cela signifie que nous sommes dans le cas de mise à jour lissée.

    % Calcul du gain de lissage A
    A = filteredCov * F' / predictedCov;

    % Mise à jour de l'état filtré lissé en utilisant le gain de lissage A
    SmoothStateOut = filteredState + A * (SmoothState - predictedState);

    % Mise à jour de la covariance filtrée lissée en utilisant le gain de lissage A
    SmoothCovOut = filteredCov + A * (SmoothCov - predictedCov);

    % Mise à jour de l'indice de mise à jour (i) à la valeur actuelle
    Iout = i;
else
    % Sinon, nous sommes dans le cas où nous commençons la mise à jour lissée, donc i est initialisé à 1.

    % Mise à jour de l'état filtré lissé sans utiliser de gain de lissage (pas de lissage)
    SmoothStateOut = filteredState;

    % Mise à jour de la covariance filtrée lissée sans utiliser de gain de lissage (pas de lissage)
    SmoothCovOut = filteredCov;

    % Mise à jour de l'indice de mise à jour (i) à 1
    Iout = i + 1;
end


