x = out.coordinates(:,1);
y = out.coordinates(:,2);
z = out.coordinates(:,3);
plot3(x,y,z,'k')
grid on
xlabel("x")
ylabel("y")
zlabel("z")
title("Rössler attractor")