# Import necessary modules
from Kalman_filter.extande_Kalman_filtre import *
from Kalman_filter.extande_Kalman_filtre_smoothing import Extended_Kalman_Filter_And_Smoothing
from Kalman_filter.Kalman_Filter import *
import numpy as np 

# Define the initial state vector
xhat = np.array([[0.1], [0.], [0.], [0.]])  # Initial state

# Define the initial covariance matrix
P = np.identity(4) * 0.001  # Initial state covariance
