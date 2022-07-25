%% Model SISOC- metoda LS
clear all
close all
clc
% Parametry symulacji
Tp = 0.05;
sigma2e = 0.1;
f = 0.04;
N = 20000;
tend = N*Tp;
TF = 8*Tp;
% Odczyt danych
sim('SystemSISOC.mdl');
u = u.Data;
time = y.Time;
y = y.Data;
yo = yo.Data;
yF = yF.Data;
ypF = ypF.Data;
uF = uF.Data;
for i = 1:size(time,1)
    fi = [-ypF(i) -yF(i) uF(i)];
    FI(i,:) = fi;
    fi = [];
end
p = inv(FI'*FI)*FI'*ypF;
ym = -p(1)*ypF-p(2)*yF+p(3)*uF;
plot(time,yo,time,ym);
