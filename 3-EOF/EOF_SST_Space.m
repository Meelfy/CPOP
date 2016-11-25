function EOF_SST_Space = EOF_SST_Space()
    SST = dlmread('data/SST_198112-201509.dat');
    % Number of samples
    m = size(SST, 1);
    % The original dimension
    n = size(SST, 2);

    % normalize_By_Col ~ each pixel
    X = normalize_By_Col(SST);

    % Calculate the covariance matrix
    C = X' * X / m;

    [U, S, V] = svd(C);

    % get the diagonal elements and the cumulative distribution probability
    percent_variance = diag(S) / sum(diag(S));
    accumulation_variance = zeros(size(percent_variance));
    
    % cumulative distribution probability
    accumulation_variance(1) = percent_variance(1);
    for i = 2:size(percent_variance)
        accumulation_variance(i) = accumulation_variance(i - 1) + percent_variance(i);
    end

    % 99.999% of variance is retained
    k = sum(accumulation_variance < 0.99999);
    Ureduce = U(:, 1:k);
    EOF_SST_Space = X * Ureduce;

    dlmwrite('data/EOF_SST_Space_0.99999.dat', EOF_SST_Space, 'delimiter', ' ');
    dlmwrite('data/EOF_SST_Spatial_mode_1-10.dat', U(:, 1:10), 'delimiter', ' ');

    % View the first 4 features after dimension reduction
    numOfPic = 4;
    for i = 1:numOfPic
        subplot(sqrt(numOfPic), sqrt(numOfPic), i);
        plot(1:m, EOF_SST_Space(:, i));
        axis([1 m min(EOF_SST_Space(:, i)) max(EOF_SST_Space(:, i))])
        set(gca,'xtick',1:60:m,'xticklabel',1981:5:2016);
        title(['SST Principal component - ', num2str(i)], 'fontsize', 16)
        xlabel('Time serises - Year');        
        set(gcf, 'position', [0 0 1200 800]);
        set(gcf, 'color', 'w')
    end
    print(gcf,'-dpng','img/SST_Principal_component_1-4');



    % View the first 4 spatial modes after dimension reduction
    numOfPic = 4;
    for i = 1:numOfPic
        subplot(sqrt(numOfPic), sqrt(numOfPic), i);
        SST_matrix = SST_vec_to_matrix(U(:, i));
        lon = 100:1:290;
        lat = -50:1:50;
        m_proj('Equidistant Cylindrical',...
               'lat', [-50 50],...
               'lon', [100 290]);
        [C,h] = m_contourf(lon,...
                           lat,...
                           flipud(SST_matrix),...
                           30,...
                           'linestyle',...
                           'none');
        m_coast('patch', [.99 .99 .99]);
        m_coast('color', 'k');
        title(['SST Spatial modes - ' num2str(i)],...
              'fontsize', 16); 
        m_grid('linestyle','none',...
               'tickdir','out',...
               'linewidth',1.5,...
               'fontsize',10,...
               'fontname','Times');
        colorbar

        set(gcf, 'position', [0 0 1200 800]);
        set(gcf, 'color', 'w')
    end
    print(gcf,'-dpng','img/SST_spatial_modes_1-4');

end