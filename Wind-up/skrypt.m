Kp = 2; %wi�ksze Kp -> jest ograniczenie sygna�u, ale nie pogarsza regulacji
Ki = 0.2; %wi�ksze Ki -> wi�kszy windup -> wi�ksze przeregulowania
y_ref = 10;   %[2,5,10,20]; %minimalna saturacja od 5
u_sat = 10;   %[5,10,20,30]; %minimalna saturacja do 20
Kc = 10;
d = 0.1*y_ref;

%Im wi�ksze u_sat tym mniejszy wska�nik IAE. Saturacja od 5 do 20. Im
%wi�ksze u_sat tym mniejszy czas regulacji i mniejsze przeregulowania.

%Im wi�ksze y_ref tym wi�kszy jest wska�nik IAE. Im wi�ksze y_ref tym
%wi�ksze przeregulowanie, czas regulacji d�u�szy

%Je�eli Kc<1 maleje to wska�nik IAE ro�nie,przeregulowanie ro�nie, im
%wi�ksze Kc tym przeregulowanie b�dzie mniejsze, czas regulacji nie
%zauwa�ono zmian.


