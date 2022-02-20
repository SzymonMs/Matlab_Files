%% MODULACJA I DEMODULACJA
srcBits=randi([0,1],20000,1); %sygna� source, 20000 bit�w
%16-QAM to powszechny schemat modulacji pojedynczej no�nej. 
%Odwzorowuje 4 bity wej�ciowe na jedn� z 16 liczb zespolonych, zwanych symbolami. 
%Dla ka�dego symbolu o warto�ci zespolonej, cz�ci rzeczywiste i urojone reprezentuj� odpowiednio
%sk�adowe wsp�fazowe i kwadraturowe przebiegu.
%�16� w 16-QAM to kolejno�� modulacji. 
%Przydatne jest przechowywanie kolejno�ci modulacji w zmiennej, dzi�ki czemu mo�na jej u�ywa� 
%w ca�ej symulacji.
modOrder=16;
modOut=qammod(srcBits,modOrder,"InputType","bit"); %modulacja 16-QAM
scatterplot(modOut);
chanOut=modOut;
demodOut=qamdemod(chanOut,modOrder,"OutputType","bit"); %demodulacja 16-QAM
check=isequal(srcBits,demodOut) %czy source i sink s� identyczne czy nie- tutaj sa wiec check=1
%% DODANIE SZUMU
%AWGN- additive white Gaussian Noise
% Simulation parameters
numBits = 20000
modOrder = 16  % for 16-QAM
% Create source bit sequence
srcBits = randi([0,1],numBits,1);
modOut=qammod(srcBits,modOrder,"InputType","bit","UnitAveragePower",true);
SNR=15 %dB
chanOut=awgn(modOut,SNR) %dodanie szumu do modulowanego sygna�u
scatterplot(chanOut);
demodOut=qamdemod(chanOut,modOrder,"OutputType","bit","UnitAveragePower",true);
check=isequal(srcBits,demodOut) %nie s� takie same ju�
%% Obliczanie bit error rate
% Simulation parameters 
numBits = 20000;
modOrder = 16;
% Create source signal and apply 16-QAM modulation
srcBits = randi([0,1],numBits,1);
modOut = qammod(srcBits,modOrder,"InputType","bit","UnitAveragePower",true);
% Apply AWGN
SNR = 15;  % dB
chanOut = awgn(modOut,SNR);
scatterplot(chanOut)
% Demodulate received signal
demodOut = qamdemod(chanOut,modOrder,"OutputType","bit","UnitAveragePower",true);
isBitError= srcBits~=demodOut;
numBitErrors=nnz(isBitError);
BER=numBitErrors/numBits; %bit error rate
%mniejsze SNR wi�kszy BNR

