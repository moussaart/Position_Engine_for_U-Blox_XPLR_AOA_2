port="COM20";
port1="COM23"; port2="COM21";
port3="COM22";
x0=[0;0.1;0;0.1];
Q=[0,0.1,0,0.1];
X_anchor=0.62;
Y_anchor=1.42;
orientation=[90,90,-90,-90];
sigma_theta=0.7;
filter_type="Comparison between the two filters";
filter_Algorithm_Selector_v0(port, port1, port2,port3,x0,Q,X_anchor,Y_anchor,orientation,sigma_theta,filter_type)