%% PART 1- OBLICZANIE STATYSTYK
load sampleletters.mat
plot(b1.Time,b1.X)
hold on
plot(b2.Time,b2.X)
hold off
plot(b1.Time,b1.Y)
hold on
plot(b2.Time,b2.Y)
hold off
aratiob=range(b1.Y)/range(b1.X)
medxb=median(b1.X,"omitnan") %mediana
medyb=median(b1.Y,"omitnan")
devxb=mad(b1.X) %œrednia wartoœci bezwzglêdnych
devyb=mad(b1.Y)
aratiov=range(v1.Y)/range(v1.X)
medxd=median(d1.X,"omitnan")
medyd=median(d1.Y,"omitnan")
devxm=mad(m1.X)
devym=mad(m1.Y)
%% PART 2- Znajdowanie Pików
load sampleletters.mat
plot(m1.Time,m1.X)
idxmin=islocalmin(m1.X)
idxmax=islocalmax(m1.X)
plot(m1.Time,m1.X)
hold on
plot(m1.Time(idxmin),m1.X(idxmin),"o")
plot(m1.Time(idxmax),m1.X(idxmax),"s")
hold off
[idxmin,prom]=islocalmin(m1.X)
plot(m1.Time,prom) %prom- prominance- miara porównania wartoœci z wartoœciami wokó³ niej
idxmin=islocalmin(m1.X,"MinProminence",0.1)
idxmax=islocalmax(m1.X,"MinProminence",0.1)
%% PART 3- Liczenie pochodnych
%prêdkoœci pisania mo¿e pomóc odró¿niæ litery od siebie
load sampleletters.mat
plot(m2.Time,m2.X)
grid
dX=diff(m2.X) %obliczanie ró¿nic x2-x1, x3-x2....
dT=diff(m2.Time)
dXdT=dX./dT %przybli¿ona pochodna
plot(m2.Time(1:end-1),dXdT)
dYdT=diff(m2.Y)./diff(m2.Time)
maxdx=max(dXdT)
maxdy=max(dYdT)
dYdT=standardizeMissing(dYdT,Inf) %zamiana NaN na Inf
%% PART 4- miary podobieñstwa
load sampleletters.mat
plot(v2.X,v2.Y,"o-")
C=corr(v2.X,v2.Y) %korelacja litery V,w jednej æwiartce silna ujemna korelacja jedno maleje drugie 
%roœnie, w drugiej dodatnia jedno i drugie roœnie proporcjonalnie
C=corr(v2.X,v2.Y,"rows","complete") %jak unikn¹c brakuj¹cych wartoœci, wynik to nie NaN
M=[v2.X(1:11) v2.Y(1:11) v2.X(12:22) v2.Y(12:22)]
Cmat=corr(M,"rows","complete") %korelacja miêdzy kolumnami M
%% PART 5- tworzenie funkcji ekstraktuj¹cej cechy
load sampleletters.mat
letter = b1;

aratio = range(letter.Y)/range(letter.X)
idxmin = islocalmin(letter.X,"MinProminence",0.1);
numXmin = nnz(idxmin)
idxmax = islocalmax(letter.Y,"MinProminence",0.1);
numYmax = nnz(idxmax)
dT = diff(letter.Time);
dXdT = diff(letter.X)./dT;
dYdT = diff(letter.Y)./dT;
avgdX = mean(dXdT,"omitnan")
avgdY = mean(dYdT,"omitnan")
corrXY = corr(letter.X,letter.Y,"rows","complete")

featurenames = ["AspectRatio","NumMinX","NumMinY","AvgU","AvgV","CorrXY"];
feat=table(aratio,numXmin,numYmax,avgdX,avgdY,corrXY)
feat = table(aratio,numXmin,numYmax,avgdX,avgdY,corrXY,'VariableNames',featurenames);
featB2 = extract(b2)
function feat=extract(letter)
aratio = range(letter.Y)/range(letter.X)
idxmin = islocalmin(letter.X,"MinProminence",0.1);
numXmin = nnz(idxmin)
idxmax = islocalmax(letter.Y,"MinProminence",0.1);
numYmax = nnz(idxmax)
dT = diff(letter.Time);
dXdT = diff(letter.X)./dT;
dYdT = diff(letter.Y)./dT;
avgdX = mean(dXdT,"omitnan")
avgdY = mean(dYdT,"omitnan")
corrXY = corr(letter.X,letter.Y,"rows","complete")

featurenames = ["AspectRatio","NumMinX","NumMinY","AvgU","AvgV","CorrXY"];
feat = table(aratio,numXmin,numYmax,avgdX,avgdY,corrXY,'VariableNames',featurenames);
end
%% PART 6- AUTOMATYCZNE WYKRYWANIE CECH
letterds = datastore("*.txt");
preprocds = transform(letterds,@scale)

featds = transform(preprocds,@extract)
data=readall(featds)
plot(data.AspectRatio,data.CorrXY)
knownchar=extractBetween(letterds.Files,"_","_") %porównywanie dwóch stringów
knownchar=categorical(knownchar)
data.Character=knownchar
gscatter(data.AspectRatio,data.CorrXY,data.Character)


function data = scale(data)
% Normalize time [0 1]
data.Time = (data.Time - data.Time(1))/(data.Time(end) - data.Time(1));
% Fix aspect ratio
data.X = 1.5*data.X;
% Center X & Y at (0,0)
data.X = data.X - mean(data.X,"omitnan");
data.Y = data.Y - mean(data.Y,"omitnan");
% Scale to have bounding box area = 1
scl = 1/sqrt(range(data.X)*range(data.Y));
data.X = scl*data.X;
data.Y = scl*data.Y;
end

function feat = extract(letter)
% Aspect ratio
aratio = range(letter.Y)/range(letter.X);
% Local max/mins
idxmin = islocalmin(letter.X,"MinProminence",0.1);
numXmin = nnz(idxmin);
idxmax = islocalmax(letter.Y,"MinProminence",0.1);
numYmax = nnz(idxmax);
% Velocity
dT = diff(letter.Time);
dXdT = diff(letter.X)./dT;
dYdT = diff(letter.Y)./dT;
avgdX = mean(dXdT,"omitnan");
avgdY = mean(dYdT,"omitnan");
% Correlation
corrXY = corr(letter.X,letter.Y,"rows","complete");
% Put it all together into a table
featurenames = ["AspectRatio","NumMinX","NumMinY","AvgU","AvgV","CorrXY"];
feat = table(aratio,numXmin,numYmax,avgdX,avgdY,corrXY,'VariableNames',featurenames);
end





