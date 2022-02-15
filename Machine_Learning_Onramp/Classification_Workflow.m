%% PART 1- Wczytanie litery i jej wyœwietlenie
letter=readtable("./machinelearning_course_files/Data/user001_D_1.txt");
plot(letter.X,letter.Y);
axis equal;
%% PART 2- Modyfikacja wartoœci
letter =readtable("./machinelearning_course_files/Data/user001_D_1.txt");
letter.X=letter.X*1.5; %zmiana bo tablet graficzny to prostok¹t a nie kwadrat
%ma wymiary 150x100 a nie 100x100
plot(letter.X,letter.Y)
axis equal
letter.Time=(letter.Time-letter.Time(1)) %czas liczymy od 0 wiêc odejmujemy warunek pocz¹tkowy
letter.Time=letter.Time/1000; %zamiana na sekundy z milisekund
plot(letter.Time,letter.X)
plot(letter.Time,letter.Y)
%% PART 3- Wyró¿nianie cech rozró¿niaj¹cych litery- wsp. kszta³tu, czas zapisu...
letter = readtable("./machinelearning_course_files/Data/user001_D_1.txt");
letter.X = letter.X*1.5;
letter.Time = (letter.Time - letter.Time(1))/1000
plot(letter.X,letter.Y)
axis equal
dur=letter.Time(end) %czas pisania litery
aratio=range(letter.Y)/range(letter.X) %wspólczynnik kszta³tu litery
%% PART 4- Ekstrakcja cech
load featuredata.mat
features
scatter(features.AspectRatio,features.Duration)
gscatter(features.AspectRatio,features.Duration,features.Character) %wykres z pogrupowanymi
%literami
%% PART 5- Tworzenie modelu dla metody KNN
load featuredata.mat
features
knnmodel=fitcknn(features,"Character") %budowa modelu
predicted=predict(knnmodel,[4,1.2]) %predykcja litery która ma aratio=4 i duration=1.2
knnmodel=fitcknn(features,"Character","NumNeighbors",5) %zmiana z 1 na 5 s¹siadów
predicted=predict(knnmodel,[4,1.2]) %inna litera ni¿ poprzednio tutaj J, tam V
%%Predykcja ca³oœci na raz
predictions=predict(knnmodel,features);
[predictions,features.Character]
%% PART 6- Ewaluacja modelu
load featuredata.mat
knnmodel = fitcknn(features,"Character","NumNeighbors",5);
testdata

predictions=predict(knnmodel,testdata)
iscorrect= (predictions==testdata.Character) %ile poprawnie zaklasyfikowano
accuracy=sum(iscorrect)/numel(predictions)
%obliczenie niepoprawnych
iswrong = predictions ~= testdata.Character
misclassrate = sum(iswrong)/numel(predictions)
confusionchart(testdata.Character,predictions) %confusion matrix
%% PART 7- Powtórka- to samo co wczeœniej dla 13 liter alfabetu angielskiego
gscatter(features.AspectRatio,features.Duration,features.Character)
knnmodel=fitcknn(features,"Character","NumNeighbors",5)
predictions=predict(knnmodel,testdata)
isscorect=(testdata.Character~=predictions)
misclass=sum(isscorect)/numel(predictions)
confusionchart(testdata.Character,predictions)







