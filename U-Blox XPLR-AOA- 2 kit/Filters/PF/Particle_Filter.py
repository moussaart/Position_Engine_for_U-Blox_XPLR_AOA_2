import numpy as np
import numpy.random as rd
import pandas as pd

import matplotlib
from matplotlib import font_manager
import matplotlib.pyplot as plt

class ParticleFilter(object):
    def __init__(self, y, n_particle, sigma, ref_points):
        # Initialize Particle Filter parameters
        self.y = y  # Observations
        self.n_particle = n_particle  # Number of particles
        self.sigma_1 = sigma  # System noise standard deviation
        self.ref_points = ref_points  # Reference points for measurements
        self.log_likelihood = -np.inf  # Log-likelihood, initially set to negative infinity

    def norm_likelihood(self, y, x, s):
        # Calculate the normalized likelihood for a given observation
        likelihood = 1
        for i in range(len(self.ref_points)):
            likelihood *= (np.sqrt(2 * np.pi * s)) ** (-1) * np.exp(-(y[i] - x[i]) ** 2 / (2 * s))
        return likelihood

    def F_inv(self, w_cumsum, idx, u):
        # Compute the inverse of the cumulative distribution function
        if np.any(w_cumsum < u) == False:
            return 0
        k = np.max(idx[w_cumsum < u])
        return k + 1

    def resampling(self, weights):
        # Perform resampling based on particle weights
        w_cumsum = np.cumsum(weights)
        idx = np.asanyarray(range(self.n_particle))
        k_list = np.zeros(self.n_particle, dtype=np.int32)

        for i, u in enumerate(rd.uniform(0, 1, size=self.n_particle)):
            k = self.F_inv(w_cumsum, idx, u)
            k_list[i] = k
        return k_list

    def resampling2(self, weights):
        # Stratified resampling method
        idx = np.asanyarray(range(self.n_particle))
        u0 = rd.uniform(0, 1 / self.n_particle)
        u = [1 / self.n_particle * i + u0 for i in range(self.n_particle)]
        w_cumsum = np.cumsum(weights)
        k = np.asanyarray([self.F_inv(w_cumsum, idx, val) for val in u])
        return k

    def simulate(self, seed=71):
        rd.seed(seed)

        T = self.y.shape[0]
        x = np.zeros((T + 1, self.n_particle, self.y.shape[1]))
        x_resampled = np.zeros((T + 1, self.n_particle, self.y.shape[1]))

        initial_x = rd.normal(0, 1, size=(self.n_particle, self.y.shape[1]))
        x_resampled[0] = initial_x
        x[0] = initial_x

        w = np.zeros((T, self.n_particle))
        w_normed = np.zeros((T, self.n_particle))
        l = np.zeros(T)

        for t in range(T):
            print("\r calculating... t={}".format(t), end="")
            for i in range(self.n_particle):
                # Apply first-order differential trend
                v = rd.normal(0, [self.sigma_1 for i in range(len(self.ref_points))], len(self.ref_points))
                x[t + 1, i] = x_resampled[t, i] + v  # Add system noise
                w[t, i] = self.norm_likelihood(self.y[t], x[t + 1, i], self.sigma_1)  # Likelihood of each particle w.r.t. y[t]
            w_normed[t] = w[t] / (np.sum(w[t]))  # Normalization
            l[t] = np.log(np.sum(w[t]))  # Log-likelihood at each time step

            k = self.resampling2(w_normed[t])  # Indices of particles obtained by resampling (stratified)
            x_resampled[t + 1] = x[t + 1, k]

        # Global log-likelihood
        self.log_likelihood = np.sum(l) - T * np.log(self.n_particle)
        self.x = x
        self.x_resampled = x_resampled
        self.w = w
        self.w_normed = w_normed
        self.l = l

    def get_filtered_value(self):
        """
        Calculate the filtered value by a weighted average of likelihood weights.
        """
        output = []
        p = 1
        for i in range(len(self.ref_points)):
            output.append(np.diag(np.dot(self.w_normed, self.x[1:, :, i].T)))
        return output
