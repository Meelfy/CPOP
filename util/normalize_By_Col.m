function [X_norm mu sigma] = normalize_By_Col(X)
    mu     = mean(X); 
    sigma  = std(X);
    X_norm = (X - ones(size(X))*diag(mu))./(ones(size(X))*diag(sigma));
end