%% PART 1- Wczytanie litery i jej wy�wietlenie
letter=readtable("./machinelearning_course_files/Data/user001_D_1.txt");
plot(letter.X,letter.Y);
axis equal;
%% PART 2- Modyfikacja warto�ci
letter =readtable("./machinelearning_course_files/Data/user001_D_1.txt");
letter.X=letter.X*1.5; %zmiana bo tablet graficzny to prostok�t a nie kwadrat
%ma wymiary 150x100 a nie 100x100
plot(letter.X,letter.Y)
axis equal
letter.Time=(letter.Time-letter.Time(1)) %czas liczymy od 0 wi�c odejmujemy warunek pocz�tkowy
letter.Time=letter.Time/1000; %zamiana na sekundy z milisekund
plot(letter.Time,letter.X)
plot(letter.Time,letter.Y)
%% PART 3- Wyr�nianie cech rozr�niaj�cych litery- wsp. kszta�tu, czas zapisu...
letter = readtable("./machinelearning_course_files/Data/user001_D_1.txt");
letter.X = letter.X*1.5;
letter.Time = (letter.Time - letter.Time(1))/1000
plot(letter.X,letter.Y)
axis equal
dur=letter.Time(end) %czas pisania litery
aratio=range(letter.Y)/range(letter.X) %wsp�lczynnik kszta�tu litery
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
predicted=predict(knnmodel,[4,1.2]) %predykcja litery kt�ra ma aratio=4 i duration=1.2
knnmodel=fitcknn(features,"Character","NumNeighbors",5) %zmiana z 1 na 5 s�siad�w
predicted=predict(knnmodel,[4,1.2]) %inna litera ni� poprzednio tutaj J, tam V
%%Predykcja ca�o�ci na raz
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
%% PART 7- Powt�rka- to samo co wcze�niej dla 13 liter alfabetu angielskiego
gscatter(features.AspectRatio,features.Duration,features.Character)
knnmodel=fitcknn(features,"Character","NumNeighbors",5)
predictions=predict(knnmodel,testdata)
isscorect=(testdata.Character~=predictions)
misclass=sum(isscorect)/numel(predictions)
confusionchart(testdata.Character,predictions)







