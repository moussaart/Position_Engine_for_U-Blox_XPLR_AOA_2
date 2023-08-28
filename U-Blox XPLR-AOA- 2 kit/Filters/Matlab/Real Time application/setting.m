% Anchors' positions (used for later calculations)
X_anchor = 0.62;
Y_anchor = 1.42;

% Define reference points (anchors) as a matrix [x, y]
ref_points = [0 0; X_anchor 0; X_anchor Y_anchor; 0 Y_anchor];
sigma_theta=0.7;
% Get the number of anchors (reference points)
N = length(ref_points);

% Initial state vector (4 elements) representing the system's initial conditions
x0 = [0.1; 0.1; 0.1; 0.1];

% Covariance matrix Q (4x4) representing the uncertainties in the initial state
Q = [0 0.1 0 0.5];

% Sampling frequency (number of samples per second)
f = 1000;

% Time Step (time duration between two consecutive samples)
dt = 1 / f;

% Initialization of the Unscented Kalman Filter (UKF) with custom parameters
% Parameters for the UKF
alpha = 1;   % UKF tuning parameter
beta = 10;   % UKF tuning parameter
kappa = 3;   % UKF tuning parameter

% State transition matrix F (4x4) to propagate the state from time step t to t+1
F = [1 dt 0 0;
     0 1  0 0;
     0 0  1 dt;
     0 0  0 1];

% Create an Unscented Kalman Filter object (ukf) using custom transitionFcn and measurementFcn
ukf = Inititaliztion_filter_UKF(x0,alpha,beta,kappa,sigma_theta,Q,ref_points,dt);

% Initialize some variables (not clear from the provided code what they are used for)
SmoothState = zeros(4, 1);
SmoothCov = zeros(4);
smooth_test = 0;
% Nested function definition for state transition


