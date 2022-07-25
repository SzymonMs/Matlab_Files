%% Metoda RLS_Lambda
clear all
clc
tend = 1500;
Tp = 0.1;
c1o = 0.7;
Td = 500;
f = 0.025;
sim('system.mdl');
b2o = b2o.Data;
u = u.Data;
time = y.Time;
y = y.Data;
yo = yo.Data;
ro = 10;
PLS = ro*eye(3);
pls =[];
pls(1,:) = [0,0,0];
ym = [];
ym(1) = 0;
ym(2) = 0;
plss = [];
plss(1,:) = [0,0,0];
plss(2,:) = [0,0,0];
tra = [];
tra(1) = 0;
tra(2) = 0;
lambda = .98;
eps_max = .5;
tr_min = 30;
for i = 3:size(time,1)
   fi = [-y(i-1), -y(i-2), u(i-2)]';
   PLS = (PLS-(PLS*(fi)*fi'*PLS)/(lambda+fi'*PLS*(fi)))/lambda;
   k = PLS*fi;
   eps = y(i)-fi'*pls';
   pls = pls+k'*eps;
   plss(i,:) = pls;
   ym(i) = -pls(1)*ym(i-1)-pls(2)*ym(i-2)+pls(3)*u(i-2);
   tra(i) = trace(PLS);
   if abs(eps) > eps_max & trace(PLS) < tr_min
       PLS = diag([0,0,1]);
   end
end
ym = ym';
plot(time,y,time,ym);
legend('y_o','y_{pred}');