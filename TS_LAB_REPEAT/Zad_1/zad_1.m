clear all;close all;clc;
%% Podpunkt 1
s=tf('s');
G=1/(2*s^2+3*s+0.5);
%ltiview(G);
L=[1];
M=[2 3 0.5];
[A,B,C,D]=tf2ss(L,M);
bieguny=eig(A);
%Inercja drugiego rzêdu
G_zerowa_sprezystosc=1/(2*s^2+3*s);
%ltiview(G_zerowa_sprezystosc)
%Ca³ka z inercj¹ (ca³ka rzeczywista)
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
plot(t,x,t,y,t,x2,t,y2); %nie s¹ bo to inne zmienne stanu
%% Podpunkt 3

