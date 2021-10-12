s=tf('s');
k=5; %wzmocnienie
T=3; %sta豉 czasowa
ksi=0.3; %wsp馧czynnik t逝mienia
G1=k; %Cz這n proporcjonalny
G2=k/s; %Cz這n ca趾uj鉍y idealny
G3=k/(1+s*T); %Cz這n inercyjny 1 rz璠u
G4=k/(T^2*s^2+2*ksi*T*s+1); %Cz這n oscylacyjny
G5=k/(s*(1+s*T)); %Cz這n ca趾uj鉍y rzeczywisty
G6=k*s; %Cz這n r騜niczkuj鉍y idealny
G7=k*s/(1+s*T); %Cz這n r騜niczkuj鉍y rzeczywisty
ltiview(G2,G3,G4,G5,G6,G7)