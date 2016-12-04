function Silhouette_value()
    clear; clc;
    PREC = dlmread('data/Prec_198112-201504.dat')';
    for k = 2:100
        [Idx_PREC] = kmeans(PREC, k, 'Distance', 'correlation');
        silh = silhouette(PREC, Idx_PREC, 'correlation');
        silhouette_value(k) = mean(silh);
    end
    plot(2:100, silhouette_value(2:100))
    xlabel('Number of clusters', 'fontsize', 16)
    ylabel('Silhouette value', 'fontsize', 16)
    title('Silhouette value', 'fontsize', 16)
    set(gcf, 'color', 'w')
    print(gcf, '-dpng', 'img/Silhouette_value_2~100')
end