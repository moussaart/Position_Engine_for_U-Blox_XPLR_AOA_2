# Import necessary modules
from Mapping import Ellipse, Car2Pol, Pol2Car, Triangulation, Square
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# Standard deviation of error on the angle measurement in radians used to test each algorithm
sigma0 = 0.2

# List containing different standard deviation values for the angle measurement error used for simulation and comparison between algorithms
list_sigma_error = [0.01, 0.05, 0.1, 0.2, 0.5, 0.7, 0.9, 1.1, 1.3]

# Anchor positions
ref_points = [(0, 0), (5, 0), (5, 5), (0, 5)]

# Particle number list for simulating the effect of particle number on the particle filter
n_particles = [50, 100, 200]

# Sampling frequency
f = 1000

# Data size used for simulation
n = 10 * f

# Time Step
dt = 1 / f

# Time vector
t = np.linspace(0, (n - 1) * dt, n)

# Create ellipse maps for simulation
ellipse = Ellipse(a=2, b=3, n=n, tour=2)

# Get Cartesian coordinates
X, Y = ellipse.Cartesian_coordinates()

# Get measurement vector
mess = ellipse.inv_Triangulation(ref_points=ref_points)

# Add noise to measurement vector
mess_e0 = ellipse.add_noise_angulation(sigma_angle=sigma0)

# Positions associated with noisy measurement
X_e, Y_e = [], []
for index in range(mess_e0.shape[1]):
    x_e, y_e = Triangulation(mess_e0[:, index], ref_points)
    X_e.append(float(x_e))
    Y_e.append(float(y_e))

# Convert lists to arrays
X_e = np.array(X_e).reshape(X.shape)
Y_e = np.array(Y_e).reshape(X.shape)

# Save data in an Excel file
data = {
    "time": t,
    "X": X,
    "Y": Y
}
path = "data/Ellipse.xlsx"
df = pd.DataFrame(data)
df.to_excel(path, index=False)

# Initialize lists for particle filter results
PF = [[] for _ in n_particles]
X_EKF, Y_EKF = [], []
X_EKF, Y_EKF = [], []
ERROR_theta = []
ERROR0 = []
ERROR2 = []
ERROR =  []
T = []
