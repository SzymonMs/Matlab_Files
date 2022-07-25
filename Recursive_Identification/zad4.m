%% Metoda RIV_Lambda
clear all
clc
tend = 1000;
Tp = 0.1;
c1o = 0.7;
Td = 1500;
f = 0.025;
sim('system.mdl');
b2o = b2o.Data;
u = u.Data;
time = y.Time;
y = y.Data;
yo = yo.Data;
ro = 10;
PLS = ro*eye(3);
piv =[];
piv(1,:) = [0,0,0];
ym = [];
ym(1) = 0;
ym(2) = 0;
pivs = [];
pivs(1,:) = [0,0,0];
pivs(2,:) = [0,0,0];
tra = [];
tra(1) = 0;
tra(2) = 0;
lambda = .98;
eps_max = .5;
tr_min = 30;
for i = 3:size(time,1)
   ym(i) = -piv(1)*ym(i-1)-piv(2)*ym(i-2)+piv(3)*u(i-2);
   fi = [-y(i-1), -y(i-2), u(i-2)]';
   z = [-ym(i-1), -ym(i-2), u(i-2)]';
   PLS = (PLS-(PLS*z*fi'*PLS)/(lambda+fi'*PLS*z))/lambda;
   k = PLS*z;
   eps = y(i)-fi'*piv';
   piv = piv+k'*eps;
   pivs(i,:) = piv;
   tra(i) = trace(PLS);
   if abs(eps) > eps_max & trace(PLS) < tr_min
       PLS = diag([0,0,1]);
   end
end
ym = ym';
plot(time,y,time,ym);
legend('y_o','y_{pred}');