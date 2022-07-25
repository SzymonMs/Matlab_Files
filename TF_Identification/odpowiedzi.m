%% step1
t1=step1(:,1);
s1=step1(:,2);
plot(t1,s1,'color','r');
k=(s1(100)-s1(50))/(t1(100)-t1(50));
s=tf('s');
G1=k/s;
hold on
step(t1,G1);
hold off
%% step2
t2=step2(:,1);
s2=step2(:,2);
plot(t2,s2,'color','r');
k=5;
y_max=max(s2);
y_ust=s2(127);
p=y_max/y_ust;
ksi=0.4;
for i=1:127
    if s2(i)==y_max
            Tm=t2(i);
    end
end
T=2*Tm;
wn=2*pi/T;
G2=k*wn^2/(s^2+2*ksi*wn*s+wn^2);
hold on
step(t2,G2);
hold off
%% step 3
t3=step3(:,1);
s3=step3(:,2);
plot(t3,s3,'color','r');
k=7;
for i=1:196
    if abs(s3(i)-0.63*k)<0.1
            T=t3(i);
    end
end
G3=k/(1+s*T);
hold on
step(t3,G3);
hold off
%% step 4
t4=step4(:,1);
s4=step4(:,2);
plot(t4,s4,'color','r');
k=1;
for i=1:14916
    if abs(s4(i)-0.5*s4(14916))<0.01
            T50=t4(i);
    end
    if abs(s4(i)-0.9*s4(14916))<0.01
            T90=t4(i);
    end
end
bb=T90/T50;
b=1;
a1=1.68;
T1=T50/a1;
T2=T1*b;
G4=k/((1+s*T1)*(1+s*T2));
hold on
step(t4,G4);
hold off
%% step 5
t5=step5(:,1);
s5=step5(:,2);
plot(t5,s5,'color','r');
kT=2;
for i=1:196
    if abs(s5(i)-kT*exp(-1))<0.1
        T=t5(i);
    end
    end
k=kT*T;
G5=k*s/(1+s*T);
hold on
step(t5,G5);
hold off
%% step 6
t6=step6(:,1);
s6=step6(:,2);
plot(t6,s6,'color','r');
k=10;
for i=1:196
    if abs(s6(i)-0.5*s6(196))<0.1
            T50=t6(i);
    end
    if abs(s6(i)-0.9*s6(196))<0.1
            T90=t6(i);
    end
end
bb=T90/T50;
b=1;
a1=1.68;
T1=T50/a1;
T2=T1*b;
G6=k/((1+s*T1)*(1+s*T2));
hold on
step(t6,G6);
hold off
%% step 7
t7=step7(:,1);
s7=step7(:,2);
plot(t7,s7,'color','r');
k=(s7(100)-s7(50))/(t7(100)-t7(50));
s=tf('s');
G7=k/s;
hold on
step(t7,G7);
hold off
%% step 8
t8=step8(:,1);
s8=step8(:,2);
plot(t8,s8,'color','r');
k=0.5;
for i=1:1829
    if abs(s8(i)-0.5*s8(1829))<0.01
            T50=t8(i);
    end
    if abs(s8(i)-0.9*s8(1829))<0.01
            T90=t8(i);
    end
end
bb=T90/T50;
b=6;
a1=9.27;
T1=T90/a1;
G8=k/((1+s*T1))^b;
hold on
step(t8,G8);
hold off