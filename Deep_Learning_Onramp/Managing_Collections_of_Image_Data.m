%% PART 1
imds=imageDatastore("file*.jpg") %tworzy datastore ze wszystkich plików 
%których nazwy zaczynaj¹ siê od s³owa file i s¹ .jpg
fname=imds.Files %nazwy plików w imds
img=readimage(imds,7) %odczyt obrazów do 7 zdjêcia
preds=classify(net,imds) %klasyfikacja wszystkich zdjec w datastore imds
%Wykres pewnoœci dla danych klasyfikacji
[pred, scores]=classify(net,imds);
max(scores,[],2);
bar(max(scores,[],2))
xticklabels(preds)
xtickangle(60)
ylabel("Score of Prediction")
%% PART 2
img = imread("file01.jpg");
imshow(img)
sz=size(img) %Rozmiar zdjêcia img
net=googlenet;
inputlayer=net.Layers(1);
insz=inputlayer.InputSize %Oczekiwany rozmiar zdjêcia na wejœciu
img=imresize(img,[224,224]) %Przeskalowanie zdjêcia
imshow(img)
%% PART 3
ls *.jpg;
net = googlenet;
imds=imageDatastore("*.jpg");
auds=augmentedImageDatastore([224 224],imds); %zmiana rozmiaru ca³ego datastore
preds=classify(net,auds) %klasyfikacja wszystkiego
%% PART 4
ls *.jpg
net = googlenet
imds = imageDatastore("file*.jpg")
montage(imds) %pokazanie wszystkich zdjêc
auds=augmentedImageDatastore([224 224],imds,"ColorPreprocessing","gray2rgb")
%zmiana rozmiaru i zmiana ze skali szaroœci na sklae RGB
%% PART 5
net = googlenet;
flwrds=imageDatastore("Flowers","IncludeSubfolders",true) %W katalogu Flowers s¹ podkatalogi
preds=classify(net,flwrds);




