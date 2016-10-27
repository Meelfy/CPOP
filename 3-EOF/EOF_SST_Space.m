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
end