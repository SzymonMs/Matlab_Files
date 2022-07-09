% https://www.mathworks.com/help/matlab/ref/ode45.html
% https://www.mathworks.com/help/matlab/ref/ode45.html#bu00_4l_sep_shared-odefun
close all; clear all; clc;

% G(s) = (s-4)/(s^2+5s+7)

x0 = [0; 0];     % warunki poczatkowe
t = 0:0.01:10;     % wektor czasu
[t, x] = ode45(@odefun, t, x0);
plot(t, x(:, 2));
legend('Odpowiedü obiektu');
function dxdt = odefun(~, x)
          A = [0 -7;1 -5];
          B = [-4;1];
          R = 1;
          Q = eye(2);
          k = lqr(A,B,Q,R);
          
          y_ref = 3;
          x2_ref = y_ref;
          u_ref = -A(1,2)*x2_ref/B(1,1);
          x1_ref = (-A(2,2)*x2_ref-B(2,1)*u_ref)/A(2,1);
          
          u = u_ref+k(1)*(x1_ref-x(1))+k(2)*(x2_ref-x(2));
          dx1 = -7*x(2)-4*u;
          dx2 = x(1)-5*x(2)+u;
          dxdt = [dx1; dx2];
          
end
