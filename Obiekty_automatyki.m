s=tf('s');
k=5; %wzmocnienie
T=3; %sta�a czasowa
ksi=0.3; %wsp�czynnik t�umienia
G1=k; %Cz�on proporcjonalny
G2=k/s; %Cz�on ca�kuj�cy idealny
G3=k/(1+s*T); %Cz�on inercyjny 1 rz�du
G4=k/(T^2*s^2+2*ksi*T*s+1); %Cz�on oscylacyjny
G5=k/(s*(1+s*T)); %Cz�on ca�kuj�cy rzeczywisty
G6=k*s; %Cz�on r�niczkuj�cy idealny
G7=k*s/(1+s*T); %Cz�on r�niczkuj�cy rzeczywisty
ltiview(G2,G3,G4,G5,G6,G7)