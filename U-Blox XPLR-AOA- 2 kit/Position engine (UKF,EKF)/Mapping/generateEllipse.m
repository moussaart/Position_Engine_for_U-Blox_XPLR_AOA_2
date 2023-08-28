function ellipse = generateEllipse(a, b,X_anchor,Y_anchor,numPoints)
    % a : demi-longueur de l'ellipse selon l'axe x
    % b : demi-longueur de l'ellipse selon l'axe y
    % centerX : coordonnée x du centre de l'ellipse
    % centerY : coordonnée y du centre de l'ellipse
    % numPoints : nombre de points à générer pour l'ellipse
    
    % Générer des angles équidistants pour les points de l'ellipse
    theta = linspace(0, 2*pi, numPoints);
    
    % Calculer les coordonnées x et y des points de l'ellipse
    r = (a * b) ./ sqrt((b * cos(theta)).^2 + (a * sin(theta)).^2);
    x = r .* cos(theta)+X_anchor;
    y = r .* sin(theta)+Y_anchor;
    % Créer une matrice avec les coordonnées x et y
    ellipse = [x' y'];
end