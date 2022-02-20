%% Filtry trasnmisyjne i odpowiedzi
% Simulation parameters 
numBits = 20000;
modOrder = 16;
% Create source bit sequence and modulate using 16-QAM.
srcBits = randi([0,1],numBits,1);
modOut = qammod(srcBits,modOrder,"InputType","bit","UnitAveragePower",true);
%square-root raised cosine transmit filter-Filtr o charakterystyce
%pierwiastka z podniesionego kosinusa
txFilt=comm.RaisedCosineTransmitFilter
rxFilt =comm.RaisedCosineReceiveFilter
txFiltOut=txFilt(modOut) %modulacja
chanOut=awgn(txFiltOut,7,"measured") %skalowanie
%% OpóŸnienie filtru i BER
numBits = 20000;
modOrder = 16;  % for 16-QAM
bitsPerSymbol = log2(modOrder)  % modOrder = 2^bitsPerSymbol
txFilt = comm.RaisedCosineTransmitFilter;
rxFilt = comm.RaisedCosineReceiveFilter;

srcBits = randi([0,1],numBits,1);
modOut = qammod(srcBits,modOrder,"InputType","bit","UnitAveragePower",true);
txFiltOut = txFilt(modOut);

SNR = 7;  % dB
chanOut = awgn(txFiltOut,SNR,"measured");

rxFiltOut = rxFilt(chanOut);
demodOut = qamdemod(rxFiltOut,modOrder,"OutputType","bit","UnitAveragePower",true);
%suma d³ugosci filtrów w symbolach
delayInSymbols=(txFilt.FilterSpanInSymbols+rxFilt.FilterSpanInSymbols)/2
delayInBits=delayInSymbols*4 %dlugosc w bitach, 4 bo w 16-QAM jest 3 bity na symbol
srcAligned=srcBits(1:(end-delayInBits)) %pokrywaj¹ce siê bity
demodAligned=demodOut((delayInBits+1):end)
numBitErrors=nnz(srcAligned~=demodAligned)
BER=numBitErrors/length(srcAligned)

