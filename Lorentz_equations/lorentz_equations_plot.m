x = out.xyz(1).Data(:,1);
y = out.xyz(1).Data(:,2);
z = out.xyz(1).Data(:,3);
plot3(x,y,z,'.-')
xlabel("x")
ylabel("y")
zlabel("z")
title("Lorentz Equations")
grid on
