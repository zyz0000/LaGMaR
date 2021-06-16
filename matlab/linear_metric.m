function [linear_metric] = linear_metric(y_true, y_pred)
RMSE = sqrt(mean((y_true - y_pred).^2));
MAE = mean(abs(y_true - y_pred));
linear_metric = [RMSE, MAE];
end

