%% Generacja
sigma_kw=[0.64,1];
sigma=[0.8,1];
Tp=0.001;
N=2000;
H=tf([0.1],[1 -0.9],Tp);
tt=0:1:N-1;
tn=tt*Tp;
%%Parametr steruj¹cy
i=1;
e=sigma(i)*randn(1,N);
x=sin(2*pi*5*tn);
y=x+e;
v=lsim(H,e,tn);
%Wykresy
subplot(2,2,1)
plot(tn,e,'.')
title('Subplot 1: e(nTp)')
subplot(2,2,2)
plot(tn,x,'.')
title('Subplot 1: x(nTp)')
subplot(2,2,3)
plot(tn,y,'.')
title('Subplot 1: y(nTp)')
subplot(2,2,4)
plot(tn,v,'.')
title('Subplot 1: v(nTp)')
%% Estymacje obci¹¿one
ree=xcorr(e,'biased');
rxx=xcorr(x,'biased');
ryy=xcorr(y,'biased');
rvv=xcorr(v,'biased');
tt_negative=-(N-1):1:N-1;
ttt=tt_negative*N;
%Wykres
subplot(2,2,1)
plot(ttt,ree,'.')
title('Subplot 1: ree')
subplot(2,2,2)
plot(ttt,rxx,'.')
title('Subplot 1: rxx')
subplot(2,2,3)
plot(ttt,ryy,'.')
title('Subplot 1: ryy')
subplot(2,2,4)
plot(ttt,rvv,'.')
title('Subplot 1: rvv')

%% Estymacje nieobci¹¿one
ree=xcorr(e,'unbiased');
rxx=xcorr(x,'unbiased');
ryy=xcorr(y,'unbiased');
rvv=xcorr(v,'unbiased');
tt_negative=-(N-1):1:N-1;
ttt=tt_negative*N;
%Wykres
subplot(2,2,1)
plot(ttt,ree,'.')
title('Subplot 1: ree')
subplot(2,2,2)
plot(ttt,rxx,'.')
title('Subplot 1: rxx')
subplot(2,2,3)
plot(ttt,ryy,'.')
title('Subplot 1: ryy')
subplot(2,2,4)
plot(ttt,rvv,'.')
title('Subplot 1: rvv')
 %% Korelacja wzajemna y,x
 ryx=xcorr(y,x);
 plot(ttt,ryx,'.')


