close all; clear all; clc;
%% Load data
load('dataBenchmark.mat')
N = size(uEst,1);
u = uEst;
y = yEst;
t = 0:Ts:N*Ts-1;
%plot(t,u);
%% Metoda nieparametryczna
M=N;
Ruu=[];
xuu=xcorr(u,'unbiased');
Ruu=toeplitz(xuu((end)/2:end));
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
plot(t,h)
legend('OdpowiedŸ skokowa');
%% Metoda LS
fi = [];
FI = [];
FI(1,:)=[0,0]; %Tyle pierwszych wierszy macierzy FI ile dp-1
dp = 2 %liczba parametrów- ZAMIANA TU DO KA¯DEJ PÊTLI JU¯ NIE TRZEBA
for i = dp:N
    fi = [-y(i-1),u(i-1)];
    FI(i,:) = fi;
    fi = [];
end
p_N_LS = inv(FI'*FI)*FI'*y;
ym = [];
ym(1)=5;
for i = dp:N
    ym(i) = -p_N_LS(1)*ym(i-1)+p_N_LS(2)*u(i-1);
  
end
%% Metoda IV
z = [];
Z = [];
Z(1,:)=[0,0];
for i = dp:N
    z = [-ym(i-1), u(i-1)];
    Z(i,:) = z;
    z = [];
end
p_N_IV = inv(Z'*FI)*Z'*y;
ym2 = [];
ym2(1)=5;
pred=[]; % TAK samo tyle deklaracji ile dp-1 DA£EM 5 bo taki jest stan pocz¹tkowy obiektu
for i = dp:N
    pred(i) = -p_N_IV(1)*yVal(i-1)+p_N_IV(2)*uVal(i-1);
    ym2(i) = -p_N_IV(1)*ym2(i-1)+p_N_IV(2)*uVal(i-1);

end
plot(t,pred,t,yVal,t,ym2);
legend('predyktor','obiekt','model')
title('2 parametry')
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