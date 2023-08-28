function dynamicGUI()
    % Création de la fenêtre principale
    mainFigure = figure('Name', 'IRISA Bluetooth Localization System', 'NumberTitle', 'off', 'Position', [100, 100, 600, 400]);

    % Création des éléments à gauche
    axes('Parent', mainFigure, 'Position', [0.05, 0.2, 0.4, 0.7],'Color', 'white');
    logo = imread('image\map.png'); % Assurez-vous d'avoir le fichier image 'logo.png'
    imshow(logo);
    
    % Création des éléments à droite
    xAnchorText = uicontrol('Style', 'edit', 'Position', [350, 300, 150, 30], 'String', '', 'Callback', @xAnchorCallback);
    yAnchorText = uicontrol('Style', 'edit', 'Position', [350, 250, 150, 30], 'String', '', 'Callback', @yAnchorCallback);
    rText = uicontrol('Style', 'edit', 'Position', [350, 200, 150, 30], 'String', '', 'Callback', @rCallback);
    qText = uicontrol('Style', 'edit', 'Position', [350, 150, 150, 30], 'String', '', 'Callback', @qCallback);

    % Bouton "Commencer"
    startButton = uicontrol('Style', 'pushbutton', 'Position', [300, 50, 200, 50], 'String', 'Commencer', 'Callback', @startCallback);

    function xAnchorCallback(~, ~)
        % Fonction de rappel pour la saisie de X_anchor
        xAnchor = str2double(get(xAnchorText, 'String'));
        fprintf('X_anchor: %.2f\n', xAnchor);
    end

    function yAnchorCallback(~, ~)
        % Fonction de rappel pour la saisie de Y_anchor
        yAnchor = str2double(get(yAnchorText, 'String'));
        fprintf('Y_anchor: %.2f\n', yAnchor);
    end

    function rCallback(~, ~)
        % Fonction de rappel pour la saisie de R
        r = str2double(get(rText, 'String'));
        fprintf('R: %.2f\n', r);
    end

    function qCallback(~, ~)
        % Fonction de rappel pour la saisie de Q
        qString = get(qText, 'String');
        q = str2num(qString); % Convertir la chaîne en matrice
        fprintf('Q: ');
        disp(q);
    end

    function startCallback(~, ~)
        % Fonction de rappel pour le bouton "Commencer"
        xAnchor = str2double(get(xAnchorText, 'String'));
        yAnchor = str2double(get(yAnchorText, 'String'));
        r = str2double(get(rText, 'String'));
        qString = get(qText, 'String');
        q = str2num(qString);

        % Appeler le script avec les valeurs saisies
        myscripte(xAnchor, yAnchor, q, r);
    end
end
