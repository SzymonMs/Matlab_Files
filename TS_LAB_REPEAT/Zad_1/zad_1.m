clear all;close all;clc;
%% Podpunkt 1
s=tf('s');
G=1/(2*s^2+3*s+0.5);
%ltiview(G);
L=[1];
M=[2 3 0.5];
[A,B,C,D]=tf2ss(L,M);
bieguny=eig(A);
%Inercja drugiego rz�du
G_zerowa_sprezystosc=1/(2*s^2+3*s);
%ltiview(G_zerowa_sprezystosc)
%Ca�ka z inercj� (ca�ka rzeczywista)
G_zerowe_tarcie=1/(2*s^2+0.5);
%ltiview(G_zerowe_tarcie);
%Oscylacyjny
%% Podpunkt 2
r=0.5;
P=[1/r 0;0 1/r];
Alpha=P*A*inv(P);
Beta=P*B;
Gamma=C*inv(P);
Delta=D;
bieguny_2=eig(Alpha);
[L2,M2]=ss2tf(Alpha,Beta,Gamma,Delta);
%step(L2,M2)
[y,t,x]=step(A,B,C,D);
[y2,t,x2]=step(Alpha,Beta,Gamma,Delta);
%plot(t,x,t,y,t,x2,t,y2); %nie s� bo to inne zmienne stanu
%% Podpunkt 3
[M,a2]=eig(Alpha);
P_diag=M^-1;
A2=P_diag*Alpha*inv(P_diag);
B2=P_diag*Beta;
C2=Gamma*inv(P_diag);
D2=Delta;
%% Podpunkt 4
%[y,M] charakterystyka statyczna
sys=ss(Alpha, Beta, Gamma, Delta);
y_stat=-10:0.1:10;
M_stat=[];
for i=1:length(y_stat)
[M,t,x]=step(sys*y_stat(i));
M_stat(i)=M(end);
end
%plot(y_stat,M_stat);
%wzmocnienie_statyczne=2 jako wsp. kierunkowy char. statycznej i wyliczony
%z transmitancji.
%% Podpunkt 5
[y,t,x]=step(sys);
%plot(x(:,1),x(:,2))
%% Podpunkt 6
Tp=0.01;
tustin=c2d(sys,Tp,'Tustin');


