T_mianownika=[1.8, 0.5];
k=4;
T_mianownika=sort(T_mianownika,'descend');
T_licznika=[0];
Tau=0;
Tp=0;
suma_T_licznika=0;
suma_T_mianownika=0;
for i=3:length(T_mianownika)
   suma_T_mianownika=suma_T_mianownika+T_mianownika(i); 
end
for j=1:length(T_licznika)
    suma_T_licznika=suma_T_licznika+T_licznika(j);
end
Th=suma_T_licznika+suma_T_mianownika;

%Sta³a czasowa FODT
T_FODT=T_mianownika(1)+T_mianownika(2)/2
%OpóŸnienie transportowe FODT
T_o=Tau+T_mianownika(2)/2+Th+Tp/2

%Nastawy regulatora
kp=T_FODT/(2*k*T_o)
if 8*T_o<T_FODT
    Ti=8*T_o
else
    Ti=T_FODT
end

