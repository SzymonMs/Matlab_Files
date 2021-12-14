close all; clear all; clc;
x_post=[0;0];
P_post=eye(2);
Tp=0.001;
R=0.25;
Q=[0.01,2;2,0.1];
A=[1 0;Tp 1];
B=[Tp;0.5*Tp^2];
C=[0,1];
u=15;
yy=[];
x_hat=zeros(2,1/Tp);
for i=1:1/Tp
    yy(i)=10*randn;
    %yy(i)=sin(i/pi)-0.543;
    %yy(i)=tan(i/pi);
    %yy(i)=i*10-3.342;
end
yy=yy';
for k=1:1/Tp
   %predykcja
   x_pre=A*x_post+B*u;
   P_pre=A*P_post*A'+Q;
   %predykcja
   K=P_pre*C'*(C*P_pre*C'+R)^(-1);
   x_post=x_pre+K*(yy(k)-C*x_pre);
   P_post=(eye(2)-K*C)*P_pre;
   
   x_hat(:,k)=x_post;
end
tt=Tp:Tp:1/Tp*Tp;
subplot(2,1,1)
plot(tt,x_hat(2,:),'g');
legend('estymata');
subplot(2,1,2)
plot(tt,yy,'r');
legend('wzor');