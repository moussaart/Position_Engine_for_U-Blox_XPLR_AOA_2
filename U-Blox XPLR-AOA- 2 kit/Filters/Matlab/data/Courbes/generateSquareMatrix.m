function squareMatrix = generateSquareMatrix(a, b, n)
    % a : demi-longueur de l'ellipse selon l'axe x
    % b : demi-longueur de l'ellipse selon l'axe y
    % n : nombre de points à générer pour l'ellipse
    
    x_coords = [0, a, a, 0, 0];
    y_coords = [0, 0, b, b, 0];
    
    t = linspace(0, 1, n);
    t_coords = linspace(0, 1, length(x_coords));
    x = interp1(t_coords, x_coords, t, 'pchip', 'extrap');
    y = interp1(t_coords, y_coords, t, 'pchip', 'extrap');
    
    x = x - ones(size(x)) * a / 2;
    y = y - ones(size(y)) * b / 2;
    squareMatrix=[x' y'];
end
