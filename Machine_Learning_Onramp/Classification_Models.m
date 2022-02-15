%% PART 1- Trenowanie modelu
load letterdata.mat
traindata
histogram(traindata.Character)
boxplot(traindata.MADX,traindata.Character) %boxplot
classificationLearner %otwiera Classsification Learner App
%% PART 2- Predykcja
load letterdata.mat
traindata
knnmodel = fitcknn(traindata,"Character","NumNeighbors",5,"Standardize",true,"DistanceWeight","squaredinverse");
testdata
predLetter=predict(knnmodel,testdata)
miss=(predLetter~=testdata.Character)
misclassrate=sum(miss)./numel(predLetter)
testloss=loss(knnmodel,testdata) %miara b³êdnej klasyfikacji, uwzglêdniaj¹ca prawd. wyst¹pienia klas
%loss(knnmodel,traindata)=0
%% PART 3- Poszukiwanie powszechnych b³êdnych klasyfikacji
load letterdata.mat
load predmodel.mat
testdata
predLetter
confusionchart(testdata.Character,predLetter);
confusionchart(testdata.Character,predLetter,"RowSummary","row-normalized")
falseneg=((testdata.Character=="U")&(predLetter~="U")) %litery to U i predykcja to nie U
fnfiles=testfiles(falseneg) %nazwy plików
fnpred=predLetter(falseneg) %litery
badU=readtable(fnfiles(4))
plot(badU.X,badU.Y) %wykres U mylonego z N
title("Prediction: "+string(fnpred(4)))
%% PART 4- Funkcje badawcze
load letterdata.mat
load predmodel.mat
traindata
testdata
predLetter
idx = (traindata.Character == "N") | (traindata.Character == "U");
UorN = traindata(idx,:)
idx = (testdata.Character == "U") & (predLetter ~= "U");
fnU = testdata(idx,:)
UorN.Character=removecats(UorN.Character) %usuwanie nieu¿ywanych kategorii
UorNfeat = UorN{:,1:end-1};
fnUfeat = fnU{:,1:end-1};
parallelcoords(UorNfeat,"Group",UorN.Character) %wartoœc cech dla ka¿dej obserwacji w postaci linii
hold on
plot(fnUfeat(4,:),"k")
hold off






