clc ; close all ; clear 
% Remplacez les paramètres suivants par les valeurs spécifiques à votre matériel
port = 'COM20';
port1 = 'COM23';
port2 = 'COM21';
port3 = 'COM22'; % Port série sur Windows ou '/dev/ttyUSBx' sur Linux/Mac

baudrate = 1000000; % Vitesse de communication en bauds
dataBits = 8;
stopBits = 1;
parity = 'none';
theta = zeros(200,5);

% Ouvrir la connexion série
s = serial(port, 'BaudRate', baudrate, 'DataBits', dataBits, 'StopBits', stopBits, 'Parity', parity);
s2 = serial(port1, 'BaudRate', baudrate, 'DataBits', dataBits, 'StopBits', stopBits, 'Parity', parity);
s3 = serial(port2, 'BaudRate', baudrate, 'DataBits', dataBits, 'StopBits', stopBits, 'Parity', parity);
s4 = serial(port3, 'BaudRate', baudrate, 'DataBits', dataBits, 'StopBits', stopBits, 'Parity', parity);
fopen(s);
fopen(s2);
fopen(s3);
fopen(s4);

I=5000;
dt=10/I;
j="===================================================================================================";
try
 for t=2:I
    % Lecture de la réponse du matériel
    response1 = fscanf(s);
    response2 = fscanf(s2);
    response3 = fscanf(s3);
    response4 = fscanf(s4);
    response={response1 , response2 , response3 ,response4};
    disp(j);
    for i=1:4
        if strncmp(response{i}, '+UUDF', 5)
         if response{i}(6)~='P'
            disp(['Réponse reçue du matériel : ' int2str(i) " " response{i}]);
            list=strsplit(response{i}, ',');
            theta(t,i+1) = str2double(list{3});
         else 
              theta(t,i+1) = theta(t-1,i+1);
         end
        else 
            theta(t,i+1) = theta(t-1,i+1);
        end
       theta(t,1)=t*dt;
    end 
   fprintf('I = %s\n', mat2str(t));

 end 
catch ex
    fclose(s);
    fclose(s2);
    fclose(s3);
    fclose(s4);
end


% Close the serial ports
fclose(s);
fclose(s2);
fclose(s3);
fclose(s4);
% Save data to a CSV file

path = 'data\real_time_data_avec_obs.xlsx';
columnNames = {'time', 'alpha1', 'alpha2','alpha3','alpha4'};
writetable(array2table(theta,'VariableNames',columnNames), path);
