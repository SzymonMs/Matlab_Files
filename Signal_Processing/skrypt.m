%plot(NoiseSig(:,1),NoiseSig(:,2),'.',NoiseSig(:,1),NoiseSig(:,3),'.')
N=1000
f=1/N*(0:N)
k=-1000:1000

%bez filtra
m1=mean(NoiseSig(:,2))
v1=var(NoiseSig(:,2))
ac1=xcorr(NoiseSig(:,2),'biased');
f1=abs(fft(NoiseSig(:,2)));

%z filtrem
m2=mean(NoiseSig(:,3))
v2=var(NoiseSig(:,3))
ac2=xcorr(NoiseSig(:,3),'biased');
f2=abs(fft(NoiseSig(:,3)));

%figure
%plot(f,f2)
%hold on
%plot(f,f1,'r')
%hold off

% figure
% plot(k,ac1)
% figure
% plot(k,ac2,'r')

figure
hist(NoiseSig(:,2),51)
figure
hist(NoiseSig(:,3),51)