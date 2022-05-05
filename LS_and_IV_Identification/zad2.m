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

%% Model odwzoru_W_estowania statycznego w zależności od rodzaju szumu
u = u_C_est; %%TUTAJ WPISZ ODPOWIEDNI SYGNAŁ U
y = y_C_est; %%TUTAJ WPISZ ODPOWIEDNI SYGNAŁ Y
data = y_C_est; %%TUTAJ WPISZE ODPOWIEDNIE data
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
%% Metoda IV
z = [];
Z = [];
Z(1,:)=[0,0];
for i = 2:size(data,1)
    z = [-fup(i-1), u(i-1)];
    Z(i,:) = z;
    z = [];
end
p_N_IV = inv(Z'*FI)*Z'*y;
fup2 = [];
fup2(1)=0;
for i = 2:size(data,1)
    fup2(i) = p_N_IV(1)*fup(i-1)+p_N_IV(2)*u(i-1);
end
plot(u,fup2,'DisplayName','LS');
hold on
plot(u_C_wer,y_C_wer,'DisplayName','Pomiar');
hold off
T1=-1*Tp/log(p_N_IV(1));
k1=p_N_IV(2)/(1-exp(-1*Tp/T1));
%% Sprawdzenie
k0=2;
T0=0.5;
s=tf('s');
G=k0/(1+s*T0);
G1=k1/(1+s*T1);
step(G,G1);

