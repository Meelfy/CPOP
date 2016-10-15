function K_Means_Clustering()
    % The clustering results of the k-means algorithm are displayed,
    % and the regions are numbered manually according to the rules
    % Because the algorithm is stochastic, the algorithm is no longer running. 
    % Directly using the previously processed results
    Prec_zones_9_manually = dlmread('data/Prec_zones_9_manually.dat');
    [c,h] = contourf(flipud(Prec_zones_9_manually));
    set(gca,'xtick',1:20:128,'xticklabel',72.25:10:135.75);
    set(gca,'ytick',1:10:72,'yticklabel',18.25:5:53.75);
    title('K-means clustering results','fontsize',16); 
    xlabel('Longitude/°E','fontsize',14);  
    ylabel('Latitude/°N','fontsize',14); 
    colorbar;
    set(gcf, 'color', 'w')
    gtext('1','fontsize',14),
    gtext('2','fontsize',14),
    gtext('3','fontsize',14),
    gtext('4','fontsize',14),
    gtext('5','fontsize',14),
    gtext('6','fontsize',14),
    gtext('7','fontsize',14),
    gtext('8','fontsize',14),
    gtext('9','fontsize',14);
    print(gcf,'-dpng','img/K-means_Clustering_Results')
end