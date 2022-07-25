close all; clear all; clc;
%% Load data
load('dataBenchmark.mat')
N = size(uEst,1);
u = uEst;
y = yEst;
t = 0:Ts:N*Ts-1;
%plot(t,u);
%% Metoda korelacyjna
M=N;
Ruu=[];
xuu=xcorr(u,'unbiased');
Ruu=toeplitz(xuu((end)/2:end));
xyu=xcorr(y,u,'unbiased');
r_yu=[];
for i=1:M
   r_yu(i)=xyu(i);
end
gm=pinv(Ruu)*r_yu';
plot(t,gm);
title('Odpowiedü impulsowa');
h=[];
h(1)=0;
for i=2:M+1
    gg=gm(1:i-1);
    h(i-1)=Ts*sum(gg);
end
figure
plot(t,h)
title('Odpowiedü skokowa');
%% Metoda LS
fi = [];
FI = [];
FI(1,:)=[0,0,0,0];
FI(2,:)=[0,0,0,0];
FI(3,:)=[0,0,0,0]; %Tyle pierwszych wierszy macierzy FI ile dp-1
dp = 4; %liczba parametrÛw- ZAMIANA TU DO KAØDEJ P TLI JUØ NIE TRZEBA
for i = dp:N
    fi = [-y(i-1),-y(i-2),-y(i-3), u(i-3)];
    FI(i,:) = fi;
    fi = [];
end
p_N_LS = inv(FI'*FI)*FI'*y;
ym = [];
ym(1)=5.2;
ym(2)=5.2;
ym(3)=5.2;
for i = dp:N
    %ym(i) = -p_N_LS(1)*y(i-1)-p_N_LS(2)*y(i-2)-p_N_LS(3)*y(i-3)+p_N_LS(4)*u(i-1);
    ym(i) = -p_N_LS(1)*ym(i-1)-p_N_LS(2)*ym(i-2)-p_N_LS(3)*ym(i-3)+p_N_LS(4)*u(i-3);
end
%% Metoda IV
z = [];
Z = [];
Z(1,:)=[0,0,0,0];
Z(2,:)=[0,0,0,0];
Z(3,:)=[0,0,0,0];
for i = dp:N
    z = [-ym(i-1),-ym(i-2),-ym(i-3), u(i-3)];
    Z(i,:) = z;
    z = [];
end
p_N_IV = inv(Z'*FI)*Z'*y;
ym2 = [];
ym2(1)=5;
ym2(2)=5;
ym2(3)=5;
pred=[];
for i = dp:N
    pred(i) = -p_N_IV(1)*yVal(i-1)-p_N_IV(2)*yVal(i-2)-p_N_IV(3)*yVal(i-3)+p_N_IV(4)*uVal(i-3);
end
for i = dp:N
    ym2(i) = -p_N_IV(1)*ym2(i-1)-p_N_IV(2)*ym2(i-2)-p_N_IV(3)*ym2(i-3)+p_N_IV(4)*uVal(i-3);
end
plot(t,pred,t,yVal,t,ym2);
legend('predyktor','obiekt','model')
title('4 parametry')
%% Weryfikacja
e = yVal-ym2';
Vn = (e'*e)/N;
AIC = N*log(Vn)+2*dp;
SIC = N*log(Vn)+2*dp*log(N);
FPE = Vn*(1+dp/N)/(1-dp/N);
Mi=1/N*(Z'*FI);
my = mean(yVal)*ones(1,N)';
txt = sprintf('AIC: %f \nSIC: %f \nFPE: %f \nV*: %f',AIC,SIC,FPE,Vn);
disp(txt);