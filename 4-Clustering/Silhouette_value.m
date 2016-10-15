function Silhouette_value()
    PREC = dlmread('data\Prec_198112-201504.dat')';
    for k = 2:30
        [Idx_PREC] = kmeans(PREC, k, 'Distance', 'correlation', 'rep', 100);
        silh = silhouette(PREC, Idx_PREC, 'correlation');
        silhouette_value(k) = mean(silh);
    end
    plot(2:30, silhouette_value)
    xlabel('Number of clusters', 'fontsize', 16)
    ylabel('Silhouette value', 'fontsize', 16)
    title('Silhouette value', 'fontsize', 16)
    set(gcf, 'color', 'w')
    print(gcf, '-dpng', 'img/Silhouette_value')
end