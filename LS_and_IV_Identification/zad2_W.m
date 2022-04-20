close all
clc
%% Wczytanie danych
load IdentWsadowaDyn.mat;
u_W = DaneDynW(:,1);
y_W = DaneDynW(:,2);
u_C = DaneDynC(:,1);
y_C = DaneDynC(:,2);
u_W_est = DaneDynW(1:floor(size(DaneDynW,1))/2,1);
y_W_est = DaneDynW(1:floor(size(DaneDynW,1))/2,2);
u_W_wer = DaneDynW(floor(size(DaneDynW,1))/2+1:size(DaneDynW,1),1);
y_W_wer = DaneDynW(floor(size(DaneDynW,1))/2+1:size(DaneDynW,1),2);
u_C_est = DaneDynC(1:floor(size(DaneDynC,1))/2,1);
y_C_est = DaneDynC(1:floor(size(DaneDynC,1))/2,2);
u_C_wer = DaneDynC(floor(size(DaneDynC,1))/2+1:size(DaneDynC,1),1);
y_C_wer = DaneDynC(floor(size(DaneDynC,1))/2+1:size(DaneDynC,1),2);
Tp=0.01;
N=4001;
t=0:Tp:(N-1)*Tp;

%% Model odwzoru_W_estowania statycznego w zale¿noœci od rodzaju szumu
u = u_W_est; %%TUTAJ WPISZ ODPOWIEDNI SYGNA£ U
y = y_W_est; %%TUTAJ WPISZ ODPOWIEDNI SYGNA£ Y
data = y_W_est; %%TUTAJ WPISZE ODPOWIEDNIE data
fi = [];
FI = [];
dp = 2;
FI(1,:)=[0,0];
for i = 2:size(data,1)
    fi = [y(i-1), u(i-1)];
    FI(i,:) = fi;
    fi = [];
end
p_N_LS = inv(FI'*FI)*FI'*y;
fup = [];
fup(1)=0;
for i = 2:size(data,1)
    fup(i) = p_N_LS(1)*fup(i-1)+p_N_LS(2)*u(i-1);
end
%plot(u,fup,'DisplayName','LS');
%hold on
%plot(u_W_wer,y_W_wer,'DisplayName','Pomiar');
%hold off
T=-1*Tp/log(p_N_LS(1));
k=p_N_LS(2)/(1-exp(-1*Tp/T));
%% Sprawdzenie
k0=2;
T0=0.5;
s=tf('s');
G=k0/(1+s*T0);
G1=k/(1+s*T);
step(G,G1);