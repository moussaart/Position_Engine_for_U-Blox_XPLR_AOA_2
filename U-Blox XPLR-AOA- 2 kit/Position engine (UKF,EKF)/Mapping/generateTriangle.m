function triangleMatrix = generateTriangle(sideLength,X_anchor,Y_anchor,n)
    % sideLength : longueur du côté du triangle équilatéral
    % n : nombre de points à générer pour le triangle
    
    x_coords = [0, sideLength/2, sideLength, 0];
    y_coords = [0, sideLength*sqrt(3)/2, 0, 0];
    
    t = linspace(0, 1, n);
    t_coords = linspace(0, 1, length(x_coords));
    x = interp1(t_coords, x_coords, t, 'pchip', 'extrap')+X_anchor/2;
    y = interp1(t_coords, y_coords, t, 'pchip', 'extrap')+Y_anchor/2;
    
    triangleMatrix = [x' y'];
end