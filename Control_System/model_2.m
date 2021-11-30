clear all;clc;
kp=1.025; Ti=2; %Nastawy regulatora wyznaczone metod¹ SIMC
Tp=0.01; %Okres próbkowania
%Równania stanu obiektu
A=[0 1; -10/9 -23/9];B=[0;1];C=[40/9, 0];D=0;
obj=ss(A,B,C,D);
%Dyskretyzacja
sys_d=c2d(obj,Tp,'zoh');
Ad=sys_d.A;Bd=sys_d.B;Cd=C;Dd=D;
%UAR
M=20/Tp; %Liczba kroków
y=zeros(1,M);e=zeros(1,M);u=zeros(1,M);ise=zeros(1,M); %Zerowe wektory sygna³ów wej.,
%uchybu,sterowania,ca³kowego wskaŸnika jakoœci
e_sum=0; %suma uchybu potrzebna dla cz³onu ca³kuj¹cego
w=1;x=[0;0]; %wartoœæ zadana, wektor x
for k=2:M
%Regulator
e(k)=w-y(k-1);e_sum=e_sum+e(k); %obliczenie uchybu i sygna³u dla cz³onu ca³kuj¹cego
ise(k)=sum(e.^2)*Tp; %obliczenie ca³kowego wskaŸnika jakoœci
u(k)=kp*e(k)+e_sum*Tp*kp/Ti; %sygna³ steruj¹cy
%Obiekt    
x=Ad*x+Bd*u(k);
y(k)=Cd*x+Dd*u(k);
end
tt=(1:M)*Tp; %oœ czasu
ww=w*ones(1,M); %sygna³ wartoœci zadanej na potrzeby wykresu
%plot(tt,y); hold on; plot(tt,ww); hold off; %wykres wartoœci zadanej i sygna³u wy.
%plot(tt,u); %przebieg sygna³u steruj¹cego
plot(tt,ise); %przebieg sygna³u ISE
