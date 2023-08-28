run("add_path.m");

% Paramètres de l'ellipse
a = 5; % Demi-longueur selon l'axe x
b = 3; % Demi-longueur selon l'axe y
centerX = 2; % Coordonnée x du centre
centerY = 4; % Coordonnée y du centre
n = 10000; % Nombre de points pour représenter l'ellipse
% sampling frequency
f = 1000;

% Time Step
dt = 1 / f;
time=dt*n;
time_steps=0:dt:time-dt;
% Générer la matrice des coordonnées de l'ellipse
Ellipsematrix = generateEllipseMatrix(a,b,0,0,n);
Squarematrix=generateSquareMatrix(a,b,n);
HexagonMatrix=generateHexagonMatrix(a,n);
TriangleMatrix = generateTriangleMatrix(a,n);

%MatrixForm= struct('Ellipse', Ellipsematrix, 'Square', Squarematrix,'Hexagon',HexagonMatrix,'Triangle',TriangleMatrix);

MatrixForm={ Ellipsematrix,  Squarematrix ,HexagonMatrix ,TriangleMatrix};
lableForm=["data\Ellipsematrix.xlsx",  "data\Squarematrix.xlsx" ,"data\HexagonMatrix.xlsx" ,"data\TriangleMatrix.xlsx"];

for i=1:4
    path=lableForm(i);
    columnNames = {'time', 'X', 'Y'};
    writetable(array2table([time_steps' MatrixForm{i}] ,'VariableNames',columnNames), path);
end



