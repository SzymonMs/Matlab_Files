%% Generacja sygna³ów
Tp=.001; %[s]
N=2000;
n=0:1:N-1;
tn=n*Tp;
sigma_kw=1;
sigma=sqrt(sigma_kw);
x=sin(2*pi*5*tn)+0.5*sin(2*pi*10*tn)+0.25*sin(2*pi*30*tn);
e=sigma*randn(1,N);
H=tf([.1],[1 -.9],Tp);
v=lsim(H,e,tn);
%% Wykresy
subplot(2,2,1)
plot(tn,x,'.','color','r')
title('x(nTp)')
subplot(2,2,2)
plot(tn,e,'.','color','b')
title('e(nTp)')
subplot(2,2,3)
plot(tn,v,'.','color','g')
title('v(nTp)')
%% Widmo
f=Tp/N*(0:N-1);
ff=abs(fft(x))*Tp;
subplot(2,2,4)
plot(f,ff)
title('fft(x)')
%% Tw Parsevala
E1x=Tp*sum(x.*x);
E2x=1/(N*Tp)*sum(ff.*ff);
delta_E=E1x-E2x;
%% Estymata gêstoœci widmowej mocy- metoda periodogramowa i korelogramowa
N=2000;
pe=[]; %do przechowywania wyników z periodogramowej
ef=fft(e); 
for i=0:N-1
    pe(i+1)=1/(N*Tp)*abs(ef(i+1).*ef(i+1));
end
Mw=N/2;
ko=[]; %do przechowywania wyników z korelogramowej
xx=xcorr(e,'biased');
omega=2*pi/N;
for kk=1:N
    sss=0; %do sumowania
    for k=-Mw:1:Mw
        if abs(k)>Mw
            sss=sss+0; %bez znaczenia tutaj
        else
            %w=1;  %okno prostok¹tne
            w=0.5*(1+cos(k*pi/Mw));  %okno Hamminga
            if k<0
                aa=abs(k); %z parzystoœci funkcji autokorelacji
            else
                if k==0
                    aa=1; %trik ¿eby unikn¹æ b³êdu z zerowym indeksem w Matlabie
                else
                    aa=k; %dla dodatnich indeksów
                end
            end
            sss=sss+w*xx(aa)*exp(-1i*omega*kk*k);
        end
    end
    ko(kk)=sss*Tp; %przypisanie wartoœci
    sss=0; %reset sumy
end
figure
plot(abs(ko))
title('Metoda korelogramowa');
figure
plot(pe)
title('Metoda periodogramowa');


