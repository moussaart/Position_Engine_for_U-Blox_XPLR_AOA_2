Copyright (c) 2023 IRISA Lab, Inc.

# Position_Engine_for_U-Blox_XPLR_AOA_2
## PFE Project:
Comprehensive Documentation for Hybrid Indoor Localization System utilizing Low-Power Radio in Dense Environments
Copyright (c) 2023 IRISA Lab, Inc.

## Project Overview:
The attached document provides an extensive overview of a PFE project involving the development of a cutting-edge hybrid indoor localization system. This system leverages low-power radio technology to achieve accurate positioning in challenging indoor environments. The documentation includes detailed explanations of the source code used in the project, specifically the u-blox XPLR-AOA-2 kit.

## Project Structure:
The project is structured as follows:

### U-Blox XPLR-AOA-2 kit:
   This section covers the source code related to the Qorvo component and is organized into two key subdirectories: "Filters" and "Position Engine."

   - Filters:
     - Convolutional Neural Network (CNN):
       - Architecture.pdf: Details the architecture of the CNN-based filter.
     - Extended Kalman Filter (EKF):
       - EKF.py: Python script implementing the EKF algorithm.
       - Algorithm.pdf: Explains the EKF algorithm.
     - Kalman Filter (KF):
       - KF.py: Python script for the Kalman Filter.
       - Algorithm.pdf: Provides insights into the KF algorithm.
     - Particle Filter (PF):
       - PF.py: Python script for the Particle Filter.
       - Algorithm.pdf: Outlines the PF algorithm.

   - Position Engine:
     - assets/: Contains all functions utilized within the position engine.
     - data/: Data-related resources.
     - Extended Kalman Filter (Position Engine):
       - Without smoothing.m: MATLAB script for EKF without smoothing.
       - On line smoothing.m: MATLAB script for online smoothing.
       - RTS smoothing.m: MATLAB script for RTS smoothing.
       - Real time/:
         - update.m: Update function.
         - init.m: Initialization function.
     - image/: Image resources.
     - Mapping/: Mapping-related resources.
     - Unscented Kalman Filter (Position Engine):
       - Without smoothing.m: MATLAB script for UKF without smoothing.
       - On line smoothing.m: MATLAB script for online smoothing.
       - RTS smoothing.m: MATLAB script for RTS smoothing.
       - Algorithm.pdf: Algorithm description.
       - Real time/:
         - update.m: Update function.
         - init.m: Initialization function.
     - GUI.mlapp: MATLAB App Designer application for the graphical user interface.

### Project Extras:
- Postion engine test youtube video: Video demonstration of the position engine in action.
   - ERL :[https://www.youtube.com/watch?v=tquWET2qrWE]
- Ublox REAL TIME SIMULATION youtube video: Exemple of real time test of the position using U-Blox systeme.
   - URL :[https://www.youtube.com/watch?v=SIrkJQvxj7k]
- u-blox Position Engine Structure.png: Image depicting the structure of the u-blox position engine.

For a more comprehensive and organized presentation of the project, please refer to the directory structure provided in the documentation. If you have any questions or require further information, please do not hesitate to reach out.

Best regards,
