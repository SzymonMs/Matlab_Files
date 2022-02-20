%% OFDM- ORTHOGONAL FREQUENCY DIVISION MULTIPLEXING 
%% Zastosowanie IFFT
numBits = 32768;  % power of 2, to optimize performance of fft/ifft
modOrder = 16;  % for 16-QAM
srcBits = randi([0,1],numBits,1);
qamModOut = qammod(srcBits,modOrder,"InputType","bit","UnitAveragePower",true);
scatterplot(qamModOut)
title("16-QAM Signal")

ofdmModOut=ifft(qamModOut)
ofdmDemodOut=fft(chanOut)
scatterplot(ofdmDemodOut)
%% Ekualizer
odOrder = 16;  % for 16-QAM
bitsPerSymbol = log2(modOrder)  % modOrder = 2^bitsPerSymbol

mpChan = [0.8; zeros(7,1); -0.5; zeros(7,1); 0.34];  % multipath channel
SNR = 15   % dB, signal-to-noise ratio of AWGN
numCarr=8192
numBits=numCarr*bitsPerSymbol
cycPrefLen=32
ofdmModOut=ofdmmod(qamModOut,numCarr,cycPrefLen)
ofdmDemodOut=ofdmdemod(chanOut,numCarr,cycPrefLen)
scatterplot(ofdmDemodOut)
mpChanFreq=fftshift(fft(mpChan,numCarr))
eqOut=ofdmDemodOut./mpChanFreq
scatterplot(eqOut)
%% Zerowe "podnoœne"
modOrder = 16;  % for 16-QAM
bitsPerSymbol = log2(modOrder)  % modOrder = 2^bitsPerSymbol
mpChan = [0.8; zeros(7,1); -0.5; zeros(7,1); 0.34];  % multipath channel
SNR = 15   % dB, signal-to-noise ratio of AWGN
numCarr = 8192;  % number of subcarriers
cycPrefLen = 32;  % cyclic prefix length
%stra¿nicy pasma
numGBCarr=numCarr/16
gbLeft=1:numGBCarr
gbRight=(numCarr-numGBCarr+1):numCarr
dcIdx=numCarr/2+1
nullIdx=[gbLeft dcIdx gbRight]'
numDataCarr = numCarr - length(nullIdx)
numBits = numDataCarr*bitsPerSymbol;
ofdmModOut=ofdmmod(qamModOut,numCarr,cycPrefLen,nullIdx)
ofdmDemodOut=ofdmdemod(chanOut,numCarr,cycPrefLen,cycPrefLen,nullIdx)
mpChanFreq=fftshift(fft(mpChan,numCarr))
mpChanFreq(nullIdx)=[]
eqOut=ofdmDemodOut./mpChanFreq
scatterplot(eqOut)


