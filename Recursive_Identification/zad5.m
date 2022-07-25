%% Filtracja Kalmana dla  b³¹dzenia parametru b2o
clear all
clc
% Parametry symulacji
tend = 1500;
Tp = 0.1;
c1o = 0.7;
Td = 500;
f = 0.025;
% Symulacja i odczyt danych
sim('system.mdl');
b2o = b2o.Data;
u = u.Data;
time = y.Time;
y = y.Data;
yo = yo.Data;
% Dane do obliczeñ
ro = 1;
P = ro*eye(3);
p=[0;0;0];
ym = [];
ym(1) = 0;
ym(2) = 0;
%V = diag([1,1,1]*10^(-4));
V = diag([0,0,.01]);
k = [1;1;1];
eps = 0;
eps_max = .5;
tr_min = 1;
ppp = [];
for i = 3:size(time,1)
    fi = [-y(i-1); -y(i-2); u(i-2)];
    P = P+V;
    p = p+k*eps;
    eps = y(i)-fi'*p;
    k = P*fi*pinv(1+fi'*P*fi);
    P = P-k*fi'*P;
    ym(i) = -p(1)*ym(i-1)-p(2)*ym(i-2)+p(3)*u(i-2);
    ppp(i,:) = p;
   if abs(eps) > eps_max & trace(P) < tr_min
       P = diag([0,0,1]);
   end
end
ym = ym';
figure
plot(time,y,time,ym);
legend('y_o','y_{m}');
figure
plot(time,b2o,time,ppp(:,3))
legend('b2o','b_{est}');