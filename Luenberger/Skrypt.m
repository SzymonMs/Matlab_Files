clear all;clc;
A=[0 -2;1 2];
B=[0;1];
C=[4 0];
D=0;
s=[-2-i,-2+i];
eig(A);
ob=ss(A,B,C,D);
%step(ob); %Obiekt niestabilny
Kx=-place(A,B,s);
A2=A+B*Kx;
ob2=ss(A2,B,C,D);
%step(ob2); Obiekt stabilny
s2=[-3,-3];
Lo=acker(A',C',s2);