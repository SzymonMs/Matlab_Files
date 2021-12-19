%RLC CIRCUIT G(s)=1/(Ls^2+Rs+1/C)
clear all;clc;close all;
L=10e-3; %10mH
C=1000e-6; %1000uF
R=1e3; %1k

[x1,x2]=meshgrid(-10:0.1:10,-10:0.1:10);
V=1/(2*C)*x1+L/2*x2;
Vdot=1/(2*C)*x1+L/2*x2;
figure; plot3(x1,x2,Vdot);
grid on; xlabel('x1');ylabel('x2');zlabel('Vdot');
figure; plot3(x1,x2,V);
grid on; xlabel('x1');ylabel('x2');zlabel('V');
