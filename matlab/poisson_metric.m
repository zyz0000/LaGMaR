function [poisson_metric] = poisson_metric(y_true, y_pred)
    RMSE = sqrt(mean((y_true - y_pred).^2));
    NMSE = sum((y_true - y_pred).^2) / sum(y_true.^2);
    MAE = mean(abs(y_true - y_pred));
    poisson_metric = [RMSE, NMSE, MAE];
end