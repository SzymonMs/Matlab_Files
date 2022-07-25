close all; clear all; clc;
load('dataBenchmark.mat')
N = size(uEst,1);
u = uEst;
y = yEst;
t = 0:Ts:N*Ts-1;
%plot(t,u);

M=N;
Ruu=[];
xuu=xcorr(u,'unbiased');
for i=1:M
    for j=1:M
       Ruu(i,j)= xuu(j);
    end
end
xyu=xcorr(y,u,'unbiased');
Ryu=[];
for i=1:M
   Ryu(i)=xyu(i);
end
gm=pinv(Ruu)*Ryu'/Ts;
plot(gm);
h=[];
h(1)=0;
for i=2:M+1
    gg=gm(1:i-1);
    h(i-1)=Ts*sum(gg);
end
plot(h)
%% Metoda LS
dp = 3;
fi = [];
FI = [];
FI(1,:) = [0,0,0];
FI(2,:) = [0,0,0];
for i = 3:N
    fi = [-y(i-1),-y(i-2), u(i-2)];
    FI(i,:) = fi;
    fi = [];
end
p_N_LS = inv(FI'*FI)*FI'*y;
ym = [];
ym(1) = 5;
ym(2) = 5;
for i = dp:N
    ym(i) = -p_N_LS(1)*ym(i-1)-p_N_LS(2)*ym(i-2)+p_N_LS(3)*u(i-2);
end
%% Metoda IV
z = [];
Z = [];
Z(1,:) = [0,0,0];
Z(2,:) = [0,0,0];
for i = dp:N
    z = [-ym(i-1),-ym(i-2), u(i-2)];
    Z(i,:) = z;
    z = [];
end
p_N_IV = inv(Z'*FI)*Z'*y;
ym2 = [];
ym2(1) = 5;
ym2(2) = 5;
ym = [];
for i = dp:N
    pred(i) = -p_N_IV(1)*yVal(i-1)-p_N_IV(2)*yVal(i-2)+p_N_IV(3)*uVal(i-2);
    ym2(i) = -p_N_IV(1)*ym2(i-1)-p_N_IV(2)*ym2(i-2)+p_N_IV(3)*uVal(i-2);
end
plot(t,pred,t,yVal,t,ym2);
legend('predyktor','obiekt','model')
title('3 parametry')
e = yVal-ym2';
Vn = (e'*e)/N;
AIC = N*log(Vn)+2*dp;
SIC = N*log(Vn)+2*dp*log(N);
FPE = Vn*(1+dp/N)/(1-dp/N);
Mi=1/N*(Z'*FI);
cond=sqrt(max(eig(Mi'*Mi)))/sqrt(min(eig(Mi'*Mi)));
my = mean(yVal)*ones(1,N)';
XXXX=sprintf('AIC: %f \nSIC: %f \nFPE: %f \ncond: %f \nV*: %f',AIC,SIC,FPE,cond,Vn);
disp(XXXX);