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

    numOfPic = 4;
    for i = 1:numOfPic
        subplot(sqrt(numOfPic), sqrt(numOfPic), i);
        plot(1:m, EOF_SST_Space(:, i));
        axis([1 m min(EOF_SST_Space(:, i)) max(EOF_SST_Space(:, i))])
        set(gca,'xtick',1:60:m,'xticklabel',1981:5:2016);
        title(['SST Principal component ', num2str(i)])
        xlabel('Time serises - Year');        
        set(gcf, 'position', [0 0 1200 800]);
        set(gcf, 'color', 'w')
    end
    print(gcf,'-dpng','img/SST_Principal_component_1-4')
end