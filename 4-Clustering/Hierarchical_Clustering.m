function Hierarchical_Clustering()
    clear all; clc;
    PREC = dlmread('data/Prec_198112-201504.dat')';
    eucD = pdist(PREC, 'correlation');
    clustTreeEuc = linkage(eucD, 'average');
    cophenet(clustTreeEuc, eucD);
    figure;clf;
    [h, clusters] =  dendrogram(clustTreeEuc, 20);
    set(gca, 'TickDir', 'out', 'TickLength', [.002 0], 'XTickLabel', []);
    set(gcf, 'color', 'w')
    title('Hierarchical Clustering', 'fontsize', 16)

    print(gcf,'-dpng','img/Clusters_Hierarchical_Clustering')
end