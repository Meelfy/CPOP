function ACI_Optimal_Clusters()
    K_max = 200;
    PRCP = dlmread('data/Prec_198112-201504.dat')';

    disp('This may take some time...');

    AIC = zeros(1,K_max);
    GM = cell(1,K_max);
    for k = 1:K_max
        GM{k} = gmdistribution.fit(PRCP, k, 'Regularize', 1e-5);
        AIC(k)= GM{k}.AIC;
    end
    [min_AIC,num_Components] = min(AIC);

    plot(AIC,'o'),hold on,plot(AIC)
    xlabel('Number of clusters','fontsize',16)
    ylabel('AIC value','fontsize',16)
    title('Akaike information criterion','fontsize',16)
    set(gcf,'color','w')

    dlmwrite(['data/AIC_value_', num2str(K_max), '_Optimal_23', '.dat'], AIC, 'delimiter', ' ');
    
    print(gcf,'-dpng',['img/Clusters_AIC_', num2str(K_max)])
end