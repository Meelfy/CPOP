function [X_norm mu sigma] = normalize_By_Row(X)
    X = X';
    [X_norm mu sigma] = normalize_By_Col(X);

    X_norm = X_norm';
    mu = mu';
    sigma = sigma';
end