%% PART 1- Tworzenie datastore
letterds = datastore("*_M_*.txt")
data=read(letterds)
plot(data.X,data.Y)
data=read(letterds)
plot(data.X,data.Y)
data=readall(letterds)
plot(data.X,data.Y)
%% PART 2- DODAWANIE DATA TRANSFORMATION
letterds = datastore("*_M_*.txt");
data = read(letterds);
data = scale(data);
plot(data.X,data.Y)
axis equal
plot(data.Time,data.Y)
ylabel("Vertical position")
xlabel("Time")
preprocds=transform(letterds,@scale) %uzycie funkcji scale do modyfikacji danych
plot(readall(preprocds).Time,readall(preprocds).Y)
function data=scale(data)
data.Time = (data.Time - data.Time(1))/1000;
data.X = 1.5*data.X;
end
function data=scale_2(data) %normalizacja danych
data.Time = (data.Time - data.Time(1))/1000;
data.X = data.X - mean(data.X);
data.Y = data.Y - mean(data.Y);
end
function data=scale_3(data) %uwzglêdnienie omitnan sprawia ze NaN s¹ omijane
data.Time = (data.Time - data.Time(1))/1000;
data.X = data.X - mean(data.X,"omitnan");
data.Y = data.Y - mean(data.Y,"omitnan");
end
