function Plotting_results(ErrorThetas,ErrorStates,filterThetas,filteredStates,SmoothThetas,SmoothStates,Thetas,States,sigma,ref_points,smooth)
 % Plotting results
    % Tracer les valeurs estimées (filtrées) et les erreurs pour chaque angle
    N = length(ref_points);
    T = size(Thetas, 1);
    f=T/10;
    dt=1/f;
    timeSteps = (1:T)*dt;
    figure;
    for i = 1:N  
        switch i
            case 1
                subplot(2, 4, 1);
            case 2 
                subplot(2, 4, 2);
            case 3 
                subplot(2, 4, 5);
            case 4
                subplot(2, 4, 6);
        end 
    
        hold on 
        plot(timeSteps, ErrorThetas(:, i), 'g:','LineWidth',0.5) % Mesures bruitées
        plot(timeSteps, filterThetas(:, i), "b--",'LineWidth',1) % Mesures filtrées (estimées)
        if smooth==1
            plot(timeSteps, SmoothThetas(:, i), "r-.",'LineWidth',1.5) % Mesures lissées
        end
        plot(timeSteps, Thetas(:, i), 'k','LineWidth',2) % Mesures bruitées

        xlabel('Temps en s');
        ylabel(sprintf('Theta %d (rad)', i));
        title(sprintf('Theta %d (t)', i));
        if smooth==1
         legend('Error','Estimated',"Smoothed","Without noise" );
        else
        legend('Error','Estimated',"Without noise" );
        end
        grid on;
    end 
    
    
    % Pour X
    subplot(2,2,2);
    hold on 
    
    plot(timeSteps, ErrorStates(:,1), 'g:','LineWidth',0.5); % X bruité (Mesures bruitées)
    plot(timeSteps, filteredStates(1, :), "b--",'LineWidth',1); % X filtré (estimé)
    if smooth==1
         plot(timeSteps, SmoothStates(1,:), "r-.",'LineWidth',1.5); % Mesures lissées
    end
    
    plot(timeSteps, States(:,1), 'k','LineWidth',2); % X bruité (Mesures bruitées)
    xlabel('Temps en s');
    ylabel('X Position (m)');
    if smooth==1
         legend('Error','Estimated',"Smoothed","Without noise" );
    else
        legend('Error','Estimated',"Without noise" );
    end
    
    title(sprintf('X(t) avec Sigma=%d rad et f_e=%d Hz', sigma,f));
     y_lim=[min(ErrorStates(:,1))-1,max(ErrorStates(:,1))+1];
     ylim(y_lim);
    grid on;
    

    % Pour Y 
    subplot(2,2,4);
    hold on 
    plot(timeSteps, ErrorStates(:,2), 'g:','LineWidth',0.5) % X bruité (Mesures bruitées)
    plot(timeSteps, filteredStates(3, :), "b--",'LineWidth',1) % X filtré (estimé)
    if smooth==1
         plot(timeSteps, SmoothStates(3,:), "r-.",'LineWidth',1.5) % Mesures lissées
    end
    
    plot(timeSteps, States(:,2), 'k','LineWidth',2) % X bruité (Mesures bruitées)
    xlabel('Temps en s');
    ylabel('Y Position (m)');
    if smooth==1
         legend('Error','Estimated',"Smoothed","Without noise" );
    else
        legend('Error','Estimated',"Without noise" );
    end
    title(sprintf('Y(t) avec Sigma=%d rad et f_e=%d Hz', sigma,f));
    y_lim=[min(ErrorStates(:,2))-1,max(ErrorStates(:,2))+1];
    ylim(y_lim);
    grid on;


figure;
hold on ; 
scatter(ErrorStates(:,1),ErrorStates(:,2),'b', 'filled',...
        'MarkerEdgeColor',[0 .5 .5],...
        'MarkerFaceColor',[0 .7 .7],...
        'LineWidth',0.25);
scatter(filteredStates(1, :),filteredStates(3, :),'g', 'filled','LineWidth',0.5)
if smooth==1
    scatter(SmoothStates(1, :),SmoothStates(3, :),'r', 'filled','LineWidth',0.5); % Mesures lissées
end

plot(States(:,1),States(:,2),'k','LineWidth',1)
xlabel('X en m');
ylabel('Y en m');
if smooth==1
         legend('Error','Estimated',"Smoothed","Without noise" );
else
        legend('Error','Estimated',"Without noise" );
end

for i = 1:size(ref_points, 1)
    x_i = ref_points(i, 1);
    y_i = ref_points(i, 2);
    
    % Plot the point as a yellow scatter plot with a label, e.g., 'R1', 'R2', ...
    scatter(x_i, y_i, 100, 'filled', 'MarkerFaceColor', 'yellow','DisplayName',['R', num2str(i)]);
    text(x_i + 0.1, y_i + 0.1, ['R', num2str(i)]);
end
title(sprintf('XY graphe avec Sigma=%d rad et f_e=%d Hz', sigma,f));
%x_lim=[-1,max(ref_points(:,1))+1];
%y_lim=[-1,max(ref_points(:,2))+1];
%xlim(x_lim);
%ylim(y_lim);


grid on;
end