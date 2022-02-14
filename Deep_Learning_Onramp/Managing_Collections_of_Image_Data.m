%% PART 1
imds=imageDatastore("file*.jpg") %tworzy datastore ze wszystkich plik�w 
%kt�rych nazwy zaczynaj� si� od s�owa file i s� .jpg
fname=imds.Files %nazwy plik�w w imds
img=readimage(imds,7) %odczyt obraz�w do 7 zdj�cia
preds=classify(net,imds) %klasyfikacja wszystkich zdjec w datastore imds
%Wykres pewno�ci dla danych klasyfikacji
[pred, scores]=classify(net,imds);
max(scores,[],2);
bar(max(scores,[],2))
xticklabels(preds)
xtickangle(60)
ylabel("Score of Prediction")
%% PART 2
img = imread("file01.jpg");
imshow(img)
sz=size(img) %Rozmiar zdj�cia img
net=googlenet;
inputlayer=net.Layers(1);
insz=inputlayer.InputSize %Oczekiwany rozmiar zdj�cia na wej�ciu
img=imresize(img,[224,224]) %Przeskalowanie zdj�cia
imshow(img)
%% PART 3
ls *.jpg;
net = googlenet;
imds=imageDatastore("*.jpg");
auds=augmentedImageDatastore([224 224],imds); %zmiana rozmiaru ca�ego datastore
preds=classify(net,auds) %klasyfikacja wszystkiego
%% PART 4
ls *.jpg
net = googlenet
imds = imageDatastore("file*.jpg")
montage(imds) %pokazanie wszystkich zdj�c
auds=augmentedImageDatastore([224 224],imds,"ColorPreprocessing","gray2rgb")
%zmiana rozmiaru i zmiana ze skali szaro�ci na sklae RGB
%% PART 5
net = googlenet;
flwrds=imageDatastore("Flowers","IncludeSubfolders",true) %W katalogu Flowers s� podkatalogi
preds=classify(net,flwrds);




