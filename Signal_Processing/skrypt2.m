t=0:1:1000;
%x=StochasticProcess(2,:);
%plot(t,x,'*')
file=load('StochasticProcess.mat');
M_r=[];
V_r=[];
M_n=[];
V_n=[];
%n1=file.StochasticProcess(1,:);
n1=0:1000;
n2=2:501;
for i = 2:size(file.StochasticProcess,1)
   w = file.StochasticProcess(i,:);
   M_r(i-1)=mean(w);
   V_r(i-1)=var(w);
end
for i=1:1001
   M_n(i)=mean(StochasticProcess(2:501,i));
   V_n(i)=var(StochasticProcess(2:501,i)); 
end
%Wykres
subplot(2,2,1)
plot(n1,M_n,'.','color','r')
title('Estymata E po czasie')
subplot(2,2,2)
plot(n1,V_n,'.','color','g')
title('Estymata V po czasie')
subplot(2,2,3)
plot(n2,M_r,'.','color','y')
title('Estymata E po realizacji')
subplot(2,2,4)
plot(n2,V_r,'.','color','black')
title('Estymata V po realizacji')

%M=mean(M_n)
%V=mean(V_n)
M=mean(M_r)
V=mean(V_r)