prob = optimproblem("Description","Factory Location"); %empty problem
%show(prob);
x = optimvar("x");
y = optimvar("y");
X = [5 40 70];
Y = [20 50 15];
d = ((x-X).^2+(y-Y).^2).^(1/2);
dTotal = sum(d);
prob.Objective = dTotal;
show(prob);
initialGuess.x = 100;
initialGuess.y = 100;
[sol,optval] = solve(prob,initialGuess);
xOpt = sol.x
yOpt = sol.y
plotStores
hold on
scatter(xOpt,yOpt)
hold off
function plotStores()
X = [5 40 70];
Y = [20 50 15];
pgon1 = nsidedpoly(5,"Center",[X(1) Y(1)],"sidelength",3);
pgon2 = nsidedpoly(5,"Center",[X(2) Y(2)],"sidelength",3);
pgon3 = nsidedpoly(5,"Center",[X(3) Y(3)],"sidelength",3);
plot([pgon1 pgon2 pgon3])
axis equal
end