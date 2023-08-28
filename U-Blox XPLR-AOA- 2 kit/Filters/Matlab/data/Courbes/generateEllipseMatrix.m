function ellipse = generateEllipseMatrix(a, b, centerX, centerY, numPoints)
    % a : demi-longueur de l'ellipse selon l'axe x
    % b : demi-longueur de l'ellipse selon l'axe y
    % centerX : coordonnée x du centre de l'ellipse
    % centerY : coordonnée y du centre de l'ellipse
    % numPoints : nombre de points à générer pour l'ellipse
    
    % Générer des angles équidistants pour les points de l'ellipse
    angles = linspace(0, 2*pi, numPoints);
    
    % Calculer les coordonnées x et y des points de l'ellipse
    x = a * cos(angles) + centerX;
    y = b * sin(angles) + centerY;
    
    % Créer une matrice avec les coordonnées x et y
    ellipse = [x' y'];
end