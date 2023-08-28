function hexagonMatrix = generateHexagonMatrix(r, n)
   % r : rayon de l'hexagone (distance du centre aux sommets)
    % n : nombre de points à générer pour l'hexagone
    
    angles = linspace(0, 2*pi, 7);
    x_coords = r * cos(angles);
    y_coords = r * sin(angles);
    
    t = linspace(0, 1, n);
    t_coords = linspace(0, 1, length(x_coords));
    x = interp1(t_coords, x_coords, t, 'pchip', 'extrap');
    y = interp1(t_coords, y_coords, t, 'pchip', 'extrap');
    
    hexagonMatrix = [x' y'];
end