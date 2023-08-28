run("add_path.m");

sigma_theta0 = 1; % standard deviation of error on the angle muser in rad used to test each algorithm



R_ublox=[sigma_theta0;sigma_theta0;sigma_theta0;sigma_theta0];
list_sigma_error =[0.01,0.05,0.1,0.2,0.5,0.7,0.9,1.1,1.3] ;


% anchors' positions
X_anchor=0.64;
Y_anchor=1.48;
ref_points = [0 0 ; X_anchor 0 ; X_anchor Y_anchor ; 0 Y_anchor];
N=length(ref_points); %nombre des anchors

%Initial state
x0=[0;0.1;0;0.1];

%Covariance
Q=[0 0.1 0 0.1];



% Specify the file name and sheet name
file_name = 'data\real_time_data3.xlsx';
sheet_name = 'Sheet1'; % Replace with the appropriate sheet name if needed

% Read data from the Excel file

alpha = xlsread(file_name);
n=size(alpha,1);
n2=n-20;
Thetha=deg2rad(Real2Theorique(alpha(20:n-1,2:5)));

% sampling frequency
f = 1000;

% Time Step
dt = 1 / f;
time=alpha(end,1);
 








