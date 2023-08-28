import numpy as np

def Linear_Kalman_Filter(measurement, time_step, sigma):
    """
    Linear Kalman Filter for State Estimation.

    Args:
        measurement (numpy.ndarray): The measured angle(s).
        time_step (float): The time step between measurements.
        sigma (float): The standard deviation of measurement noise.

    Returns:
        xhatOut (numpy.ndarray): The updated state estimate after filtering.

    Description:
        This function implements a Linear Kalman Filter (KF) for state estimation. It takes in measurements,
        time step, and measurement noise standard deviation as input.
        
        The function initializes or uses global variables for the state estimate 'xhat_n', state covariance 'P_n',
        state transition matrix 'F_n', measurement matrix 'H_n', process noise covariance 'Q_n', and measurement
        noise covariance 'R_n'.

        The KF includes the calculation of the Jacobians for the state and measurement equations, propagation of
        the state and covariance matrices, calculation of the Kalman gain, and update of the state and covariance
        estimates based on the measurements.

        The function returns the updated state estimate 'xhatOut'.
    """
    
    global P_n, F_n, H_n, xhat_n, Q_n, R_n
    
    if 'P_n' not in globals():
        # First time through the code, initialize variables
        xhat_n = np.array([[0], [0.1], [2], [0.2], [0], [0.1], [2], [0.2]])
        P_n = np.zeros((8, 8))
        F_n = np.array([[1, time_step, 0, 0, 0, 0, 0, 0],
                        [0, 1, 0, 0, 0, 0, 0, 0],
                        [0, 0, 1, time_step, 0, 0, 0, 0],
                        [0, 0, 0, 1, 0, 0, 0, 0],
                        [0, 0, 0, 0, 1, time_step, 0, 0],
                        [0, 0, 0, 0, 0, 1, 0, 0],
                        [0, 0, 0, 0, 0, 0, 1, time_step],
                        [0, 0, 0, 0, 0, 0, 0, 1]])
        H_n = np.array([[1, 0, 0, 0, 0, 0, 0, 0],
                        [0, 0, 1, 0, 0, 0, 0, 0],
                        [0, 0, 0, 0, 1, 0, 0, 0],
                        [0, 0, 0, 0, 0, 0, 1, 0]])
        Q_n = np.diag([0, 0.2, 0, 0.2, 0, 0.2, 0, 0.2])
        R_n = np.diag([sigma**2, sigma**2, sigma**2, sigma**2])
    
    # Calculate the Jacobians for the state and measurement equations
    yhat = np.array([[float(xhat_n[0])],
                     [float(xhat_n[2])],
                     [float(xhat_n[4])],
                     [float(xhat_n[6])]])

    # Propagate the state and covariance matrices
    xhat_n = F_n.dot(xhat_n)
    P_n = F_n.dot(P_n).dot(F_n.T) + Q_n

    # Calculate the Kalman gain
    K_n = P_n.dot(H_n.T).dot(np.linalg.inv((H_n.dot(P_n).dot(H_n.T) + R_n)))

    # Calculate the measurement residual
    resid = measurement - yhat

    # Update the state and covariance estimates
    xhat_n = xhat_n + K_n.dot(resid)
    P_n = (np.eye(K_n.shape[0]) - K_n.dot(H_n)).dot(P_n)

    # Post the results
    xhatOut = xhat_n

    return xhatOut
