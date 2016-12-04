function X = recovery_By_Col(X_norm, mu, sigma)
    X = bsxfun(@times, X_norm, sigma);
    X = bsxfun(@plus, X, mu);
end