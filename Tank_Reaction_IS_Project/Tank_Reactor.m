%%Continuous Stirring Tank Reactor, Exothermic reaction- System Identification

%%@author  Szymon Murawski <szymon.murawski@student.put.poznan.pl>
%%Contributed by: Jairo ESPINOSA  ESAT-SISTA KULEUVEN  Kardinaal Mercierlaan 94  B-3001 Heverlee Belgium  espinosa@esat.kuleuven.ac.be
%%@version 1.0

%%Input q - Coolant Flow l/min
%%Outputs Ca - Concentration mol/l (only use), T - Temperature Kelvin degrees

Tp = 0.1; %[6s = 0.1 min] %sampling period time
N = 7500; % number of samples of data
load('cstr.dat');
t = cstr(:,1); %time
q = cstr(:,2); %input q
Ca = cstr(:,3); %output Ca
T = cstr(:,4); %output T
%% Plotting data - q(t), Ca(t)
figure
plot(t,q,'g');
title('Input - overview');
legend('q')
xlabel('t')
ylabel('q')
figure
plot(t,Ca,'r');
title('Output - overview');
legend('Ca');
xlabel('t')
ylabel('Ca')
%% Division of data into two sets - for estimation andfor validation
qEst = q(1:N/2,:); %input for estimation model
qVal = q(N/2+1:N,:); %input for validation model
CaEst = Ca(1:N/2,:); %output for estimation model
CaVal = Ca(N/2+1:N,:); %output for validation model
t = t(1:N/2); %new time- size of vector like size of new vectors for est. and val.
figure
plot(t,CaEst,t,CaVal);
title('Outputs for estimation and validation');
legend('CaEst','CaVal');
xlabel('t');
ylabel('CaEst, CaVal');
figure
plot(t,qEst,t,qVal);
title('Inputs for estimation and validation');
legend('qEst','qVal');
xlabel('t');
ylabel('qEst, qVal');
%% Obtaining initial knowledge
M = N/2;
Ruu = [];
xuu = xcorr(qEst,'unbiased');
Ruu = toeplitz(xuu(end/2:end));
xyu = xcorr(Ca,q,'unbiased');
r_yu = [];
for i=1:M
    r_yu(i) = xyu(i);
end
gm = pinv(Ruu)*r_yu';
figure
plot(t,gm);
title('Impulse');
legend('Impulse Response');
xlabel('t');
ylabel('gm');
h = [];
h(1) = 0;
for i=2:M+1
    gg = gm(1:i-1);
    h(i-1) = Tp*sum(gg);
end
figure
plot(t,h);
title('Step');
legend('Step Response');
xlabel('t');
ylabel('h');
%% LS and IV
% First proposition: y(n) = -p1 * y(n-1) + p2 * u(n)
% Second proposition: y(n) = -p1 * y(n-1) -p2 * y(n-2) + p3 * u(n-1)
PROPOSITION = 2;

fi = [];
FI = [];
z = [];
Z = [];
y = CaEst;
u = qEst;
uVal = qVal;

if PROPOSITION == 1
 dp = 2;
 FI(1,:) = [0,0];
 for i = dp:M
    fi = [ -y(i-1) , u(i)];
    FI(i,:) = fi;
    fi = [];
 end
p_N_LS = pinv(FI)*y;
ym = [];
ym(1) = 0;
for i = dp:M
    ym(i) = -p_N_LS(1)*ym(i-1) + p_N_LS(2)*u(i);
end
Z(1,:) = [0,0];
for i = dp:M
    z = [-ym(i-1), u(i)];
    Z(i,:) = z;
    z = [];
end
p_N_IV = inv(Z'*FI)*Z'*y;
ym2 = [];
ym2(1) = 0;
for i = dp:M
    ym2(i) = -p_N_IV(1)*ym2(i-1)+p_N_IV(2)*CaVal(i);
end
end

 if PROPOSITION == 2
 dp = 3;
 FI(1,:) = [0,0,0];
 FI(2,:) = [0,0,0];
 for i = dp:M
    fi = [ -y(i-1),-y(i-2) , u(i-1)];
    FI(i,:) = fi;
    fi = [];
 end
p_N_LS = pinv(FI)*y;
ym = [];
ym(1) = 0;
ym(2) = 0;
for i = dp:M
    ym(i) = -p_N_LS(1)*ym(i-1)-p_N_LS(2)*ym(i-2) + p_N_LS(3)*u(i-1);
end
Z(1,:) = [0,0,0];
Z(2,:) = [0,0,0];
for i = dp:M
    z = [-ym(i-1),-ym(i-2), u(i-1)];
    Z(i,:) = z;
    z = [];
end
p_N_IV = inv(Z'*FI)*Z'*y;
ym2 = [];
ym2(1) = 0;
ym2(2) = 0;
for i = dp:M
    ym2(i) = -p_N_IV(1)*ym2(i-1)+-p_N_IV(2)*ym2(i-2)+p_N_IV(3)*CaVal(i-1);
end
 end

 if PROPOSITION == 3
 dp = 4;
 FI(1,:) = [0,0,0,0];
 FI(2,:) = [0,0,0,0];
 FI(3,:) = [0,0,0,0];
 for i = dp:M
    fi = [-y(i-1),-y(i-2),-y(i-3), u(i-1)];
    FI(i,:) = fi;
    fi = [];
 end
p_N_LS = pinv(FI)*y;
ym = [];
ym(1) = 0;
ym(2) = 0;
ym(3) = 0;
for i = dp:M
    ym(i) = -p_N_LS(1)*ym(i-1)-p_N_LS(2)*ym(i-2)-p_N_LS(3)*ym(i-3) + p_N_LS(4)*u(i-1);
end
Z(1,:) = [0,0,0,0];
Z(2,:) = [0,0,0,0];
Z(3,:) = [0,0,0,0];
for i = dp:M
    z = [-ym(i-1),-ym(i-2),-ym(i-3), u(i-1)];
    Z(i,:) = z;
    z = [];
end
p_N_IV = inv(Z'*FI)*Z'*y;
ym2 = [];
ym2(1) = 0;
ym2(2) = 0;
ym2(3) = 0;
for i = dp:M
    ym2(i) = -p_N_IV(1)*ym2(i-1)+-p_N_IV(2)*ym2(i-2)-p_N_IV(3)*ym2(i-3)+p_N_IV(4)*qVal(i-1);
end
end
figure;
plot(t,CaVal,t,ym2);
title('model - IV method');
legend('Ca','IV_{model}');
xlabel('t')
ylabel('Ca')