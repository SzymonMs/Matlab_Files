s=tf('s');
Go=1/(s^2+10*s)
syms kp kd ki
kp=2;
ki=3;
kd=4;
%Gz = ((kp + ki/s) * Go) / (1+Go*kd*s+(kp + ki/s) * Go)
Gz=(Go*(kp+ki/s))/(1+Go*(kp+ki/s+kd*s))
step(Gz)