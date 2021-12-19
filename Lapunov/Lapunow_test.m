A=[0 10;-1 -3];
%eig(A);
Q=eye(2); %V'(x)=-x1^2-x2^2, zawsze dla takiego przyjecia Q
R=lyap(A',Q); %Jezeli R jest dodatnio określona to uklad jest stabilny

[x1,x2]=meshgrid(-10:0.1:10,-10:0.1:10);
Vdot=-x1.^2-x2.^2;
V=x1.^2+0.5*x2.^2+x1.*x2;
figure; plot3(x1,x2,Vdot);
grid on; xlabel('x1');ylabel('x2');zlabel('Vdot');
figure; plot3(x1,x2,V);
grid on; xlabel('x1');ylabel('x2');zlabel('V');