%% PART 1
img1=imread("file01.jpg");
imshow(img1)
%% PART 2
deepnet=googlenet;
img1 = imread("file01.jpg");
size(img1)
%imresize(img1,inputSize(1:2));
%imshow(img1)
%pred1=classify(deepnet,img1)
%% PART 3
deepnet = googlenet;
ly=deepnet.Layers %Zwaraca warstwy deepnet
inlayer=ly(1) %Pierwsz warstwa Input
insz=inlayer.InputSize %Rozmiar Input
outlayer=ly(144) %Ostatnia warstwa Output
categorynames=outlayer.Classes %Klasy dostêpne na wyjœciu
%% PART 4
img = imread("file01.jpg");
imshow(img)
net = googlenet;
categorynames = net.Layers(end).ClassNames;
[pred,scores]=classify(net,img)
bar(scores)
highscores=scores>0.01
bar(scores(highscores))
xticklabels(categorynames(highscores))



