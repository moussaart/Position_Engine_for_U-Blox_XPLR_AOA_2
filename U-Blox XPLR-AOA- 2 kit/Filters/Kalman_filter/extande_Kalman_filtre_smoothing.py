import numpy as np

def Extended_Kalman_Filter_And_Smoothing(measurement, time_step, prior_covariance, prior_state_estimate, smoothed_state_estimate, smoothed_covariance, measurement_noise_covariance, reference_points):
    """
    Extended Kalman Filter (EKF) with Online Smoothing.

    Args:
        measurement (numpy.ndarray): The measured angle(s).
        time_step (float): The time step between measurements.
        prior_covariance (numpy.ndarray): The prior covariance matrix of the state estimate.
        prior_state_estimate (numpy.ndarray): The prior state estimate.
        smoothed_state_estimate (numpy.ndarray): The initial smoothed state estimate.
        smoothed_covariance (numpy.ndarray): The initial smoothed covariance matrix.
        measurement_noise_covariance (numpy.ndarray): The measurement noise covariance matrix.
        reference_points (list of tuples): A list of reference points for measurements.

    Returns:
        XOut (numpy.ndarray): The updated state estimate after filtering.
        Pout (numpy.ndarray): The updated covariance matrix after filtering.
        x_smooth (numpy.ndarray): The updated smoothed state estimate.
        P_smooth (numpy.ndarray): The updated smoothed covariance matrix.

    Description:
        This function implements an Extended Kalman Filter (EKF) with Online Smoothing. It takes in measurements,
        time step, prior covariance, prior state estimate, smoothed state estimate, smoothed covariance, measurement
        noise covariance, and reference points as input. It then performs the EKF prediction and update steps to estimate
        the current state and covariance, as well as the online smoothing step to improve the state estimate based on
        future measurements.

        The EKF prediction includes the calculation of the Jacobian matrix 'F' for the state transition equation,
        propagation of the state and covariance matrices, calculation of the Kalman gain, and update of the state
        and covariance estimates based on the measurements.

        The online smoothing step calculates a gain 'A' to update the smoothed state estimate and covariance matrix
        based on the predicted state and covariance.

        Finally, the function returns the updated state estimate 'XOut', the updated covariance matrix 'Pout', the
        updated smoothed state estimate 'x_smooth', and the updated smoothed covariance matrix 'P_smooth'.
    """
    # Define process noise covariance matrix Q
    Q = np.diag([0, 10, 0, 10])

    # Calculate the Jacobian matrix F for the state transition equation
    F = np.array([[1, time_step, 0, 0], [0, 1, 0, 0], [0, 0, 1, time_step], [0, 0, 0, 1]])

    # Calculate initial position components
    x1 = float(prior_state_estimate[0])
    y1 = float(prior_state_estimate[2])

    # Initialize lists for estimated angles and measurement sensitivity matrix H
    yhat = []
    H = []

    # Calculate estimated angles and sensitivity matrix H for each reference point
    for anchor in reference_points:
        x_i = anchor[0]
        y_i = anchor[1]

        # Calculate angle 'a' and sensitivity coefficients 'b1' and 'b2'
        a = float(np.arctan2((y1 - y_i), (x1 - x_i)))
        b1 = (y_i - y1) / (x1 ** 2 - 2 * x1 * y1 + x_i ** 2 + y1 ** 2 + y_i ** 2)
        b2 = (x1 - x_i) / (x1 ** 2 - 2 * x1 * y1 + x_i ** 2 + y1 ** 2 + y_i ** 2)

        # Append values to H matrix and yhat list
        H.append([b1, 0, b2, 0])
        yhat.append([a])

    # Convert lists to numpy arrays
    H = np.array(H)
    yhat = np.array(yhat)

    # Propagate the state and covariance matrices using the state transition equation
    x_pred = F.dot(prior_state_estimate)
    P_pred = F.dot(prior_covariance).dot(F.T) + Q

    # Calculate the Kalman gain
    K = P_pred.dot(H.T).dot(np.linalg.inv((H.dot(P_pred).dot(H.T) + measurement_noise_covariance)))

    # Calculate the measurement residual
    residual = measurement.reshape((len(reference_points), 1)) - yhat

    # Update the state and covariance estimates
    x = x_pred + K.dot(residual)
    P = (np.eye(K.shape[0]) - K.dot(H)).dot(P_pred)

    # Calculate the gain 'A' for online smoothing
    A = P.dot(F.T).dot(np.linalg.inv(P_pred))

    # Perform online smoothing: Update smoothed state estimate and covariance matrix
    x_smooth = x + A.dot(smoothed_state_estimate - x_pred)
    P_smooth = P + A.dot(smoothed_covariance - P_pred).dot(A.T)

    # Post the results
    XOut = x
    Pout = P
    return XOut, Pout, x_smooth, P_smooth
