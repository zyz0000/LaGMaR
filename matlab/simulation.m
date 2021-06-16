function [RMR_LOGISTIC, RMR_POISSON, RMR_LINEAR, ... 
          TUCKER_LOGISTIC, TUCKER_POISSON, TUCKER_LINEAR, ...
          KRUSKAL_LOGISTIC, KRUSKAL_POISSON, KRUSKAL_LINEAR] = simulation(Tc, p, q)
      
if (p == 20 && q == 20)
    lambda_logistic = 10; 
    lambda_poisson = 10; 
    lambda_linear = 2.5;
elseif (p == 20 && q == 50)
    lambda_logistic = 20; 
    lambda_poisson = 20; 
    lambda_linear = 5;
else
    lambda_logistic = 20; 
    lambda_poisson = 20; 
    lambda_linear = 5;
end
[X, y_linear, y_logistic, y_poisson] = data_generator(Tc, p, q);
Z = randn(size(X, 3), 3);

% use logistic setting to split dataset, because there is no difference for
% poisson and linear settings
trainIndex = crossvalind("Kfold", y_logistic, 5);

[metric_rmr_logistic, metric_tucker11_logistic, metric_kruskal1_logistic] = deal(zeros(5, 5));
[metric_rmr_poisson, metric_tucker11_poisson, metric_kruskal1_poisson] = deal(zeros(5, 3));
[metric_rmr_linear, metric_tucker11_linear, metric_kruskal1_linear] = deal(zeros(5, 2));

for fold = 1:5
    test = (trainIndex == fold);
    train = ~test;
    X_train = X(:, :, train);
    X_test = X(:, :, test);
    y_train_logistic = y_logistic(train, :);
    y_train_poisson = y_poisson(train, :);
    y_train_linear = y_linear(train, :);
    y_test_logistic = y_logistic(test, :);
    y_test_poisson = y_poisson(test, :);
    y_test_linear = y_linear(test, :);
    Z_train = Z(train, :);
    Z_test = Z(test, :);
    
    Q = arrayfun(@(k) X_test(:, :, k), 1:size(X_test, 3), 'un', 0);

    %% perform matrix sparse regression
    %perform logistic setting
    [beta_logistic, B_logistic, ~] = matrix_sparsereg(Z_train, tensor(X_train), y_train_logistic, lambda_logistic, 'binomial');
    coef_rmr = double(B_logistic);
    coef_rmr = coef_rmr(:)';
    log_odds_rmr = cellfun(@(x) double(coef_rmr) * x(:), Q, 'UniformOutput', false);
    log_odds_rmr = cell2mat(log_odds_rmr') + Z_test * beta_logistic;
    prob_rmr = exp(log_odds_rmr) ./ (1 + exp(log_odds_rmr));
    y_pred_rmr_logistic = prob_rmr >= 0.5;
    
    %perform poisson setting
    [beta_poisson, B_poisson, ~] = matrix_sparsereg(Z_train, tensor(X_train), y_train_poisson, lambda_poisson, 'poisson');
    coef_rmr = double(B_poisson);
    coef_rmr =coef_rmr(:)';
    log_y_pred_rmr = cellfun(@(x) double(coef_rmr) * x(:), Q, 'UniformOutput', false);
    y_pred_rmr_poisson = exp(cell2mat(log_y_pred_rmr') + Z_test * beta_poisson);
    
    %perform linear setting
    [beta_linear, B_linear, ~] = matrix_sparsereg(Z_train, tensor(X_train), y_train_linear, lambda_linear, 'normal');
    coef_rmr = double(B_linear);
    coef_rmr =coef_rmr(:)';
    y_pred_rmr_linear = cellfun(@(x) double(coef_rmr) * x(:), Q, 'UniformOutput', false);
    y_pred_rmr_linear = cell2mat(y_pred_rmr_linear') + Z_test * beta_linear;
    
    %calculate metrics
    m1 = classification_metric(y_test_logistic', double(y_pred_rmr_logistic'), prob_rmr);
    m2 = poisson_metric(y_test_poisson', double(y_pred_rmr_poisson'));
    m3 = linear_metric(y_test_linear', double(y_pred_rmr_linear'));
    metric_rmr_logistic(fold, :) = cell2mat(struct2cell(m1));
    metric_rmr_poisson(fold, :) = m2;
    metric_rmr_linear(fold, :) = m3;

    
    %% perform tucker11 regression
    %perform logistic setting
    [bb_rk11, beta_rk11_logistic, ~] = tucker_reg(Z_train, tensor(X_train), y_train_logistic, [1, 1], 'binomial');
    coef_tucker11 = double(beta_rk11_logistic);
    coef_tucker11 = coef_tucker11(:)';
    log_odds_tucker11 = cellfun(@(x) double(coef_tucker11) * x(:), Q, 'UniformOutput', false);
    log_odds_tucker11 = cell2mat(log_odds_tucker11') + Z_test * bb_rk11;
    prob_tucker11 = exp(log_odds_tucker11) ./ (1 + exp(log_odds_tucker11));
    y_pred_tucker11_logistic = prob_tucker11 >= 0.5;
    
    %perform poisson setting
    [bp_rk11, beta_rk11_poisson, ~] = tucker_reg(Z_train, tensor(X_train), y_train_poisson, [1, 1], 'poisson');
    coef_tucker11 = double(beta_rk11_poisson);
    coef_tucker11 = coef_tucker11(:)';
    log_y_pred_tucker11 = cellfun(@(x) double(coef_tucker11) * x(:), Q, 'UniformOutput', false);
    y_pred_tucker11_poisson = exp(cell2mat(log_y_pred_tucker11') + Z_test * bp_rk11);
    
    %perform linear setting
    [bl_rk11, beta_rk11_linear, ~] = tucker_reg(Z_train, tensor(X_train), y_train_linear, [1, 1], 'normal');
    coef_tucker11 = double(beta_rk11_linear);
    coef_tucker11 = coef_tucker11(:)';
    y_pred_tucker11 = cellfun(@(x) double(coef_tucker11) * x(:), Q, 'UniformOutput', false);
    y_pred_tucker11_linear = cell2mat(y_pred_tucker11') + Z_test * bl_rk11;
    
    %calculate metrics
    m1 = classification_metric(y_test_logistic', double(y_pred_tucker11_logistic'), prob_tucker11);
    m2 = poisson_metric(y_test_poisson', double(y_pred_tucker11_poisson'));
    m3 = linear_metric(y_test_linear', double(y_pred_tucker11_linear'));
    metric_tucker11_logistic(fold, :) = cell2mat(struct2cell(m1));
    metric_tucker11_poisson(fold, :) = m2;
    metric_tucker11_linear(fold, :) = m3;

    %% perform kruskal1
    %perform logtisic setting
    [bb_rk1, beta_rk1_logistic, ~, ~] = kruskal_reg(Z_train, tensor(X_train), y_train_logistic, 1, 'binomial');
    coef_kruskal1 = double(beta_rk1_logistic);
    coef_kruskal1 = coef_kruskal1(:)';
    log_odds_kruskal1 = cellfun(@(x) double(coef_kruskal1) * x(:), Q, 'UniformOutput', false);
    log_odds_kruskal1 = cell2mat(log_odds_kruskal1') + Z_test * bb_rk1;
    prob_kruskal1 = exp(log_odds_kruskal1) ./ (1 + exp(log_odds_kruskal1));
    y_pred_kruskal1_logistic = prob_kruskal1 >= 0.5;
    
    %perform poisson setting
    [bp_rk1, beta_rk1_poisson, ~] = kruskal_reg(Z_train, tensor(X_train), y_train_poisson, 1, 'poisson');
    coef_kruskal1 = double(beta_rk1_poisson);
    coef_kruskal1 = coef_kruskal1(:)';
    log_y_pred_kruskal1 = cellfun(@(x) double(coef_kruskal1) * x(:), Q, 'UniformOutput', false);
    y_pred_kruskal1_poisson = exp(cell2mat(log_y_pred_kruskal1') + Z_test * bp_rk1);
    
    %perform linear setting
    [bl_rk1, beta_rk1_linear, ~] = kruskal_reg(Z_train, tensor(X_train), y_train_linear, 1, 'normal');
    coef_kruskal1 = double(beta_rk1_linear);
    coef_kruskal1 = coef_kruskal1(:)';
    y_pred_kruskal1 = cellfun(@(x) double(coef_kruskal1) * x(:), Q, 'UniformOutput', false);
    y_pred_kruskal1_linear = cell2mat(y_pred_kruskal1') + Z_test * bl_rk1;

    %calculate metrics
    m1 = classification_metric(y_test_logistic', double(y_pred_kruskal1_logistic'), prob_kruskal1);
    m2 = poisson_metric(y_test_poisson', double(y_pred_kruskal1_poisson'));
    m3 = linear_metric(y_test_linear', double(y_pred_kruskal1_linear'));
    metric_kruskal1_logistic(fold, :) = cell2mat(struct2cell(m1));
    metric_kruskal1_poisson(fold, :) = m2;
    metric_kruskal1_linear(fold, :) = m3;
end

%% calculate the average of five folds
RMR_LOGISTIC = mean(metric_rmr_logistic, 1);
RMR_POISSON = mean(metric_rmr_poisson, 1);
RMR_LINEAR = mean(metric_rmr_linear, 1);
TUCKER_LOGISTIC = mean(metric_tucker11_logistic, 1);
TUCKER_POISSON = mean(metric_tucker11_poisson, 1);
TUCKER_LINEAR = mean(metric_tucker11_linear, 1);
KRUSKAL_LOGISTIC = mean(metric_kruskal1_logistic, 1);
KRUSKAL_POISSON = mean(metric_kruskal1_poisson, 1);
KRUSKAL_LINEAR = mean(metric_kruskal1_linear, 1);
end