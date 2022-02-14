%% PART 1
load pathToImages
flwrds = imageDatastore(pathToImages,"IncludeSubfolders",true);
flowernames = flwrds.Labels
flwrds=imageDatastore(pathToImages,"IncludeSubfolders",true,"LabelSource","foldernames") %
%Odczytanie podfolderow i stworzenie z ich nazw labeli klas
flowernames=flwrds.Labels %nazwy labeli
%% PART 2
load pathToImages
flwrds = imageDatastore(pathToImages,"IncludeSubfolders",true,"LabelSource","foldernames")
[flwrTrain,flwrTest]=splitEachLabel(flwrds,.6) %podzia³ na zbiór testowy i
%treningowy w proprcji 60%
[flwrTrain,flwrTest]=splitEachLabel(flwrds,.8,"randomized") %podzia³ ale losowy
[flwrTrain,flwrTest]=splitEachLabel(flwrds,50) %taki podzia³ ¿e zbiór treningowy ma 50 elementów
%% PART 3
opts=trainingOptions("sgdm") %algorytm SGDM
opts=trainingOptions("sgdm","InitialLearnRate",.001) %zmiana rate jak mocno 
%zmienione zostana wagi sieci
%% PART 4
load pathToImages
load trainedFlowerNetwork flowernet info
plot(info.TrainingLoss) %info to struktura z informacjami o treningu
dsflowers = imageDatastore(pathToImages,"IncludeSubfolders",true,"LabelSource","foldernames");
[trainImgs,testImgs] = splitEachLabel(dsflowers,0.98);
flwrPreds=classify(flowernet,testImgs)
%% PART 5
load pathToImages.mat
pathToImages
flwrds = imageDatastore(pathToImages,"IncludeSubfolders",true,"LabelSource","foldernames");
[trainImgs,testImgs] = splitEachLabel(flwrds,0.98);
load trainedFlowerNetwork flwrPreds
flwrActual=testImgs.Labels
numCorrect=nnz(flwrPreds==flwrActual) %ile poprawnych klasyfikacji
fracCorrect=numCorrect/24
confusionchart(testImgs.Labels,flwrPreds) %wyœwietlenie confussion matrix

idxWrong = find(flwrPreds ~= flwrActual)
idx2 = idxWrong(2)
imshow(readimage(testImgs,idx2))
title(testImgs.Labels(idx2))







