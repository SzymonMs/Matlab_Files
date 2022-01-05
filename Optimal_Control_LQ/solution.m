% https://www.mathworks.com/help/matlab/ref/ode45.html
% https://www.mathworks.com/help/matlab/ref/ode45.html#bu00_4l_sep_shared-odefun
close all; clear all; clc;

 x0 = [0; 0];     % warunki poczatkowe - do uzupelnienia
 t = 0:0.01:10;     % wektor czasu - do uzupelnienia

% Rozwiazanie rownan oraz narysowanie przebiegow
%A=[0 -5;1 -8];
%B=[-4;1];
%C=[0,1];
%D=0;
%sys=ss(A,B,C,D);
%step(sys);
[t, x] = ode45(@odefun, t, x0);
plot(t, x(:, 2));
legend('Wyjscie');
%R=1;
%Q=eye(2);
%k=lqr(A,B,Q,R);
%u=-1.25+k(1)*(9.25-x(:,1))+k(2)*(1-x(:,2));
%plot(t, u);legend('Sterowanie', 'Czas');

function dxdt = odefun(~, x)
      % Definicja sterowania
        %  u=1; %sta³y sygna³
      %regulator P
        %  kp=0.01;
        %  e=1-x(2);
        %  u=kp*e;
      %sterowanie optymalne
          A=[0 -5;1 -8];
          B=[-4;1];
          R=1;
          Q=eye(2);
          k=lqr(A,B,Q,R);
          u=-1.25+k(1)*(9.25-x(1))+k(2)*(1-x(2));
     % Obliczanie pochodnych zmiennych stanu
        dx1 = -5*x(2)-4*u;
        dx2 = x(1)-8*x(2)+u;
        dxdt = [dx1; dx2];
end