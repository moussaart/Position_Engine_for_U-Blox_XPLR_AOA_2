import numpy as np 

def Extended_Kalman_Filter(measurement, time_step, prior_covariance, prior_state_estimate, measurement_noise_covariance, reference_points):
    """
    Extended Kalman Filter (EKF) for State Estimation.

    Args:
        measurement (numpy.ndarray): The measured angle(s).
        time_step (float): The time step between measurements.
        prior_covariance (numpy.ndarray): The prior covariance matrix of the state estimate.
        prior_state_estimate (numpy.ndarray): The prior state estimate.
        measurement_noise_covariance (numpy.ndarray): The measurement noise covariance matrix.
        reference_points (list of tuples): A list of reference points for measurements.

    Returns:
        XOut (numpy.ndarray): The updated state estimate after filtering.
        Pout (numpy.ndarray): The updated covariance matrix after filtering.
        x_pred (numpy.ndarray): The predicted state estimate.
        P_pred (numpy.ndarray): The predicted covariance matrix.

    Description:
        This function implements an Extended Kalman Filter (EKF) for state estimation. It takes in measurements,
        time step, prior covariance, prior state estimate, measurement noise covariance, and reference points as input.
        
        The EKF includes the calculation of the Jacobian matrix 'F' for the state transition equation,
        propagation of the state and covariance matrices, calculation of the Kalman gain, and update of the state
        and covariance estimates based on the measurements.

        The function returns the updated state estimate 'XOut', the updated covariance matrix 'Pout', the predicted
        state estimate 'x_pred', and the predicted covariance matrix 'P_pred'.
    """
    
    # Define process noise covariance matrix Q
    Q = np.diag([0, 10, 0, 10])
    
    # Calculate the Jacobians for the state and measurement equations
    F = np.array([[1, time_step, 0, 0], [0, 1, 0, 0], [0, 0, 1, time_step], [0, 0, 0, 1]])
    
    x1 = float(prior_state_estimate[0])
    y1 = float(prior_state_estimate[2])
    
    yhat = []
    H = []
    
    for anchor in reference_points:
        x_i = anchor[0]
        y_i = anchor[1]
        
        # Calculate angle 'a' and sensitivity coefficients 'b1' and 'b2'
        a = float(np.arctan2((y1 - y_i), (x1 - x_i)))
        b1 = (y_i - y1) / (x1**2 - 2*x1*y1 + x_i**2 + y1**2 + y_i**2)
        b2 = (x1 - x_i) / (x1**2 - 2*x1*y1 + x_i**2 + y1**2 + y_i**2)
        
        H.append([b1, 0, b2, 0])
        yhat.append([a])
        
    H = np.array(H)
    yhat = np.array(yhat)
    
    # Propagate the state and covariance matrices
    x_pred = F.dot(prior_state_estimate)
    P_pred = F.dot(prior_covariance).dot(F.T) + Q
    
    # Calculate the Kalman gain
    K = P_pred.dot(H.T).dot(np.linalg.inv((H.dot(P_pred).dot(H.T) + measurement_noise_covariance)))
    
    # Calculate the measurement residual
    residual = measurement.reshape((len(reference_points), 1)) - yhat
    
    # Update the state and covariance estimates
    x_estimate = x_pred + K.dot(residual)
    P_estimate = (np.eye(K.shape[0]) - K.dot(H)).dot(P_pred)
    
    # Post the results
    XOut = x_estimate
    Pout = P_estimate
    
    return XOut, Pout, x_pred, P_pred
