% Set the following parameters with values specific to your hardware
port = 'COM20';
port1 = 'COM23';
port2 = 'COM21';
port3 = 'COM22'; % Serial port on Windows or '/dev/ttyUSBx' on Linux/Mac
baudrate = 1000000; % Communication speed in bauds
dataBits = 8;
stopBits = 1;
parity = 'none';

% Open the serial connections
s = serial(port, 'BaudRate', baudrate, 'DataBits', dataBits, 'StopBits', stopBits, 'Parity', parity);
s2 = serial(port1, 'BaudRate', baudrate, 'DataBits', dataBits, 'StopBits', stopBits, 'Parity', parity);
s3 = serial(port2, 'BaudRate', baudrate, 'DataBits', dataBits, 'StopBits', stopBits, 'Parity', parity);
s4 = serial(port3, 'BaudRate', baudrate, 'DataBits', dataBits, 'StopBits', stopBits, 'Parity', parity);

% Open the serial connections
fopen(s);
fopen(s2);
fopen(s3);
fopen(s4);

% Initialize theta (angles) to zeros
th = [0, 0, 0, 0];
