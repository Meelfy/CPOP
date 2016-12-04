function X = recovery_By_Row(X_norm, mu, sigma)
    X_norm = X_norm';
    X = recovery_By_Col(X_norm, mu', sigma');
    X = X';
end