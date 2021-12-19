Kp = 2; %wiêksze Kp -> jest ograniczenie sygna³u, ale nie pogarsza regulacji
Ki = 0.2; %wiêksze Ki -> wiêkszy windup -> wiêksze przeregulowania
y_ref = 10;   %[2,5,10,20]; %minimalna saturacja od 5
u_sat = 10;   %[5,10,20,30]; %minimalna saturacja do 20
Kc = 10;
d = 0.1*y_ref;

%Im wiêksze u_sat tym mniejszy wskaŸnik IAE. Saturacja od 5 do 20. Im
%wiêksze u_sat tym mniejszy czas regulacji i mniejsze przeregulowania.

%Im wiêksze y_ref tym wiêkszy jest wskaŸnik IAE. Im wiêksze y_ref tym
%wiêksze przeregulowanie, czas regulacji d³u¿szy

%Je¿eli Kc<1 maleje to wskaŸnik IAE roœnie,przeregulowanie roœnie, im
%wiêksze Kc tym przeregulowanie bêdzie mniejsze, czas regulacji nie
%zauwa¿ono zmian.


