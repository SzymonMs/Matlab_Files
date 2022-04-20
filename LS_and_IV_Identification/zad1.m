close all
clc
%% Wczytanie danych
load IdentWsadowaStat.mat;
u_W = DaneStatW(:,1);
y_W = DaneStatW(:,2);
u_C = DaneStatC(:,1);
y_C = DaneStatC(:,2);
plot(u_C,y_C,'DisplayName','z szumem kolorowym');
hold on
plot(u_W,y_W,'DisplayName','z szumem bia³ym');
hold off
legend
%% Model odwzorowania statycznego w zale¿noœci od rodzaju szumu
u = u_C; %%TUTAJ WPISZ ODPOWIEDNI SYGNA£ U
y = y_C; %%TUTAJ WPISZ ODPOWIEDNI SYGNA£ Y
data = DaneStatC; %%TUTAJ WPISZE ODPOWIEDNIE data
fi = [];
FI = [];
dp = 4;
for i = 1:size(data,1)
    fi = [1 1/u(i) 1/(u(i)^2) 1/(u(i)^3)];
    FI(i,:) = fi;
    fi = [];
end
p_N_LS = inv(FI'*FI)*FI'*y;
fup = [];
for i = 1:size(data,1)
    fup(i) = p_N_LS(1)+p_N_LS(2)/u(i)+p_N_LS(3)/(u(i))^2+p_N_LS(4)/(u(i))^3;
end
plot(u,fup,'DisplayName','LS');
hold on
plot(u,y,'DisplayName','Pomiar');
hold off
legend
sigma_sq = 0; %tylko dla szumu bia³ego
for i = 1:size(data,1)
   fi = [1 1/u(i) 1/(u(i)^2) 1/(u(i)^3)];
   error = y(i)-fi*p_N_LS;
   sigma_sq = sigma_sq+error;
end
sigma_sq=sigma_sq*1/(size(data,1)-dp);