function [RMR_LOGISTIC, RMR_POISSON, RMR_LINEAR, ... 
          TUCKER12_LOGISTIC, TUCKER12_POISSON, TUCKER12_LINEAR, ...
          TUCKER22_LOGISTIC, TUCKER22_POISSON, TUCKER22_LINEAR, ...
          KRUSKAL1_LOGISTIC, KRUSKAL1_POISSON, KRUSKAL1_LINEAR, ...
          KRUSKAL2_LOGISTIC, KRUSKAL2_POISSON, KRUSKAL2_LINEAR] = simulation(R, C, Tc, p, q)
      
if (p == 20 && q == 20)
    lambda_logistic_rmr = 100; 
    lambda_poisson_rmr = 100; 
    lambda_linear_rmr = 100;
    lambda_logistic_tucker12 = 50;
    lambda_poisson_tucker12 = 5;
    lambda_linear_tucker12 = 20;
    lambda_logistic_tucker22 = 100;
    lambda_poisson_tucker22 = 50;
    lambda_linear_tucker22 = 100;
    lambda_logistic_kruskal1 = 100;
    lambda_poisson_kruskal1 = 10;
    lambda_linear_kruskal1 = 20;
    lambda_logistic_kruskal2 = 50;
    lambda_poisson_kruskal2 = 100;
    lambda_linear_kruskal2 = 100;
elseif (p == 20 && q == 50)
    lambda_logistic_rmr = 100; 
    lambda_poisson_rmr = 100; 
    lambda_linear_rmr = 100;
    lambda_logistic_tucker12 = 20;
    lambda_poisson_tucker12 = 10;
    lambda_linear_tucker12 = 50;
    lambda_logistic_tucker22 = 50;
    lambda_poisson_tucker22 = 10;
    lambda_linear_tucker22 = 100;
    lambda_logistic_kruskal1 = 100;
    lambda_poisson_kruskal1 = 100;
    lambda_linear_kruskal1 = 1;
    lambda_logistic_kruskal2 = 100;
    lambda_poisson_kruskal2 = 50;
    lambda_linear_kruskal2 = 10;
else
    lambda_logistic_rmr = 100; 
    lambda_poisson_rmr = 100; 
    lambda_linear_rmr = 100;
    lambda_logistic_tucker12 = 100;
    lambda_poisson_tucker12 = 5;
    lambda_linear_tucker12 = 10;
    lambda_logistic_tucker22 = 100;
    lambda_poisson_tucker22 = 20;
    lambda_linear_tucker22 = 20;
    lambda_logistic_kruskal1 = 100;
    lambda_poisson_kruskal1 = 100;
    lambda_linear_kruskal1 = 10;
    lambda_logistic_kruskal2 = 100;
    lambda_poisson_kruskal2 = 100;
    lambda_linear_kruskal2 = 100;
end
[X, Z, y_linear, y_logistic, y_poisson] = data_generator(R, C, Tc, p, q);

% use logistic setting to split dataset, because there is no difference for
% poisson and linear settings
trainIndex = crossvalind("Kfold", y_logistic, 5);

[metric_rmr_logistic, metric_tucker12_logistic, metric_tucker22_logistic,...
    metric_kruskal1_logistic, metric_kruskal2_logistic] = deal(zeros(5, 5));
[metric_rmr_poisson, metric_tucker12_poisson, metric_tucker22_poisson, ...
    metric_kruskal1_poisson, metric_kruskal2_poisson] = deal(zeros(5, 3));
[metric_rmr_linear, metric_tucker12_linear, metric_tucker22_linear, 
    metric_kruskal1_linear, metric_kruskal2_linear] = deal(zeros(5, 2));

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
    X_train = tensor(X_train);
    [beta_logistic, B_logistic, ~] = matrix_sparsereg(Z_train, tensor(X_train), ...
                               y_train_logistic, lambda_logistic_rmr, 'binomial');
    coef_rmr = double(B_logistic);
    coef_rmr = coef_rmr(:)';
    log_odds_rmr = cellfun(@(x) double(coef_rmr) * x(:), Q, 'UniformOutput', false);
    log_odds_rmr = cell2mat(log_odds_rmr') + Z_test * beta_logistic;
    prob_rmr = exp(log_odds_rmr) ./ (1 + exp(log_odds_rmr));
    y_pred_rmr_logistic = prob_rmr >= 0.5;
    
    %perform poisson setting
    [beta_poisson, B_poisson, ~] = matrix_sparsereg(Z_train, tensor(X_train), ...
                                y_train_poisson, lambda_poisson_rmr, 'poisson');
    coef_rmr = double(B_poisson);
    coef_rmr =coef_rmr(:)';
    log_y_pred_rmr = cellfun(@(x) double(coef_rmr) * x(:), Q, 'UniformOutput', false);
    y_pred_rmr_poisson = exp(cell2mat(log_y_pred_rmr') + Z_test * beta_poisson);
    
    %perform linear setting
    [beta_linear, B_linear, ~] = matrix_sparsereg(Z_train, tensor(X_train), ...
                                y_train_linear, lambda_linear_rmr, 'normal');
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

    
    %% perform tucker12 regression
    %perform logistic setting
    [~, B0, ~] = tucker_reg(Z_train, tensor(X_train), y_train_logistic, [1, 2], 'binomial');
    [bb_rk12, beta_rk12_logistic, ~] = tucker_sparsereg(Z_train, tensor(X_train), ...
            y_train_logistic, [1, 2], 'binomial', lambda_logistic_tucker12, 'enet', 1, 'B0', B0);
    coef_tucker12 = double(beta_rk12_logistic);
    coef_tucker12 = coef_tucker12(:)';
    log_odds_tucker12 = cellfun(@(x) double(coef_tucker12) * x(:), Q, 'UniformOutput', false);
    log_odds_tucker12 = cell2mat(log_odds_tucker12') + Z_test * bb_rk12;
    prob_tucker12 = exp(log_odds_tucker12) ./ (1 + exp(log_odds_tucker12));
    y_pred_tucker12_logistic = prob_tucker12 >= 0.5;
    
    %perform poisson setting
    [~, B0, ~] = tucker_reg(Z_train, tensor(X_train), y_train_poisson, [1, 2], 'poisson');
    [bp_rk12, beta_rk12_poisson, ~] = tucker_sparsereg(Z_train, tensor(X_train), ...
            y_train_poisson, [1, 2], 'poisson', lambda_poisson_tucker12, 'enet', 1, 'B0', B0);
    coef_tucker12 = double(beta_rk12_poisson);
    coef_tucker12 = coef_tucker12(:)';
    log_y_pred_tucker12 = cellfun(@(x) double(coef_tucker12) * x(:), Q, 'UniformOutput', false);
    y_pred_tucker12_poisson = exp(cell2mat(log_y_pred_tucker12') + Z_test * bp_rk12);
    
    %perform linear setting
    [~, B0, ~] = tucker_reg(Z_train, tensor(X_train), y_train_poisson, [1, 2], 'normal');
    [bl_rk12, beta_rk12_linear, ~] = tucker_sparsereg(Z_train, tensor(X_train), ...
            y_train_linear, [1, 2], 'normal', lambda_linear_tucker12, 'mcp', 1, 'B0', B0);
    coef_tucker12 = double(beta_rk12_linear);
    coef_tucker12 = coef_tucker12(:)';
    y_pred_tucker12 = cellfun(@(x) double(coef_tucker12) * x(:), Q, 'UniformOutput', false);
    y_pred_tucker12_linear = cell2mat(y_pred_tucker12') + Z_test * bl_rk12;
    
    %calculate metrics
    m1 = classification_metric(y_test_logistic', double(y_pred_tucker12_logistic'), prob_tucker12);
    m2 = poisson_metric(y_test_poisson', double(y_pred_tucker12_poisson'));
    m3 = linear_metric(y_test_linear', double(y_pred_tucker12_linear'));
    metric_tucker12_logistic(fold, :) = cell2mat(struct2cell(m1));
    metric_tucker12_poisson(fold, :) = m2;
    metric_tucker12_linear(fold, :) = m3;
    
   %% perform tucker22 regression
    %perform logistic setting
    [~, B0, ~] = tucker_reg(Z_train, tensor(X_train), y_train_logistic, [2, 2], 'binomial');
    [bb_rk22, beta_rk22_logistic, ~] = tucker_sparsereg(Z_train, tensor(X_train), ...
            y_train_logistic, [2, 2], 'binomial', lambda_logistic_tucker22, 'enet', 1, 'B0', B0);
    coef_tucker22 = double(beta_rk22_logistic);
    coef_tucker22 = coef_tucker22(:)';
    log_odds_tucker22 = cellfun(@(x) double(coef_tucker22) * x(:), Q, 'UniformOutput', false);
    log_odds_tucker22 = cell2mat(log_odds_tucker22') + Z_test * bb_rk22;
    prob_tucker22 = exp(log_odds_tucker22) ./ (1 + exp(log_odds_tucker22));
    y_pred_tucker22_logistic = prob_tucker22 >= 0.5;
    
    %perform poisson setting
    [~, B0, ~] = tucker_reg(Z_train, tensor(X_train), y_train_poisson, [2, 2], 'poisson');
    [bp_rk22, beta_rk22_poisson, ~] = tucker_sparsereg(Z_train, tensor(X_train), ...
            y_train_poisson, [2, 2], 'poisson', lambda_poisson_tucker22, 'enet', 1, 'B0', B0);
    coef_tucker22 = double(beta_rk22_poisson);
    coef_tucker22 = coef_tucker22(:)';
    log_y_pred_tucker22 = cellfun(@(x) double(coef_tucker22) * x(:), Q, 'UniformOutput', false);
    y_pred_tucker22_poisson = exp(cell2mat(log_y_pred_tucker22') + Z_test * bp_rk22);
    
    %perform linear setting
    [~, B0, ~] = tucker_reg(Z_train, tensor(X_train), y_train_poisson, [2, 2], 'normal');
    [bl_rk22, beta_rk22_linear, ~] = tucker_sparsereg(Z_train, tensor(X_train), ...
            y_train_linear, [2, 2], 'normal', lambda_linear_tucker22, 'mcp', 1, 'B0', B0);
    coef_tucker22 = double(beta_rk22_linear);
    coef_tucker22 = coef_tucker22(:)';
    y_pred_tucker22 = cellfun(@(x) double(coef_tucker22) * x(:), Q, 'UniformOutput', false);
    y_pred_tucker22_linear = cell2mat(y_pred_tucker22') + Z_test * bl_rk22;
    
    %calculate metrics
    m1 = classification_metric(y_test_logistic', double(y_pred_tucker22_logistic'), prob_tucker22);
    m2 = poisson_metric(y_test_poisson', double(y_pred_tucker22_poisson'));
    m3 = linear_metric(y_test_linear', double(y_pred_tucker22_linear'));
    metric_tucker22_logistic(fold, :) = cell2mat(struct2cell(m1));
    metric_tucker22_poisson(fold, :) = m2;
    metric_tucker22_linear(fold, :) = m3;

    %% perform kruskal1
    %perform logtisic setting
    [~, B0, ~, ~] = kruskal_reg(Z_train, tensor(X_train), y_train_logistic, 1, 'binomial');
    [bb_rk1, beta_rk1_logistic, ~, ~] = kruskal_sparsereg(Z_train, tensor(X_train), ...
                y_train_logistic, 1, 'binomial', lambda_logistic_kruskal1, 'enet', 1, 'B0', B0);
    coef_kruskal1 = double(beta_rk1_logistic);
    coef_kruskal1 = coef_kruskal1(:)';
    log_odds_kruskal1 = cellfun(@(x) double(coef_kruskal1) * x(:), Q, 'UniformOutput', false);
    log_odds_kruskal1 = cell2mat(log_odds_kruskal1') + Z_test * bb_rk1;
    prob_kruskal1 = exp(log_odds_kruskal1) ./ (1 + exp(log_odds_kruskal1));
    y_pred_kruskal1_logistic = prob_kruskal1 >= 0.5;
    
    %perform poisson setting
    [~, B0, ~] = kruskal_reg(Z_train, tensor(X_train), y_train_poisson, 1, 'poisson');
    [bp_rk1, beta_rk1_poisson, ~, ~] = kruskal_sparsereg(Z_train, tensor(X_train), ...
                y_train_poisson, 1, 'poisson', lambda_poisson_kruskal1, 'power', 1, 'B0', B0);
    coef_kruskal1 = double(beta_rk1_poisson);
    coef_kruskal1 = coef_kruskal1(:)';
    log_y_pred_kruskal1 = cellfun(@(x) double(coef_kruskal1) * x(:), Q, 'UniformOutput', false);
    y_pred_kruskal1_poisson = exp(cell2mat(log_y_pred_kruskal1') + Z_test * bp_rk1);
    
    %perform linear setting
    [~, B0, ~] = kruskal_reg(Z_train, tensor(X_train), y_train_linear, 1, 'normal');
    [bl_rk1, beta_rk1_linear, ~, ~] = kruskal_sparsereg(Z_train, tensor(X_train), ...
                y_train_linear, 1, 'normal', lambda_linear_kruskal1, 'enet', 1, 'B0', B0);
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
    
    %% perform kruskal1
    %perform logtisic setting
    [~, B0, ~, ~] = kruskal_reg(Z_train, tensor(X_train), y_train_logistic, 2, 'binomial');
    [bb_rk2, beta_rk2_logistic, ~, ~] = kruskal_sparsereg(Z_train, tensor(X_train), ...
                y_train_logistic, 2, 'binomial', lambda_logistic_kruskal2, 'enet', 1, 'B0', B0);
    coef_kruskal2 = double(beta_rk2_logistic);
    coef_kruskal2 = coef_kruskal2(:)';
    log_odds_kruskal2 = cellfun(@(x) double(coef_kruskal2) * x(:), Q, 'UniformOutput', false);
    log_odds_kruskal2 = cell2mat(log_odds_kruskal2') + Z_test * bb_rk2;
    prob_kruskal2 = exp(log_odds_kruskal2) ./ (1 + exp(log_odds_kruskal2));
    y_pred_kruskal2_logistic = prob_kruskal2 >= 0.5;
    
    %perform poisson setting
    [~, B0, ~] = kruskal_reg(Z_train, tensor(X_train), y_train_poisson, 2, 'poisson');
    [bp_rk2, beta_rk2_poisson, ~, ~] = kruskal_sparsereg(Z_train, tensor(X_train), ...
                y_train_poisson, 2, 'poisson', lambda_poisson_kruskal2, 'power', 1, 'B0', B0);
    coef_kruskal2 = double(beta_rk2_poisson);
    coef_kruskal2 = coef_kruskal2(:)';
    log_y_pred_kruskal2 = cellfun(@(x) double(coef_kruskal2) * x(:), Q, 'UniformOutput', false);
    y_pred_kruskal2_poisson = exp(cell2mat(log_y_pred_kruskal2') + Z_test * bp_rk2);
    
    %perform linear setting
    [~, B0, ~] = kruskal_reg(Z_train, tensor(X_train), y_train_linear, 2, 'normal');
    [bl_rk2, beta_rk2_linear, ~, ~] = kruskal_sparsereg(Z_train, tensor(X_train), ...
                y_train_linear, 2, 'normal', lambda_linear_kruskal2, 'enet', 1, 'B0', B0);
    coef_kruskal2 = double(beta_rk2_linear);
    coef_kruskal2 = coef_kruskal2(:)';
    y_pred_kruskal2 = cellfun(@(x) double(coef_kruskal2) * x(:), Q, 'UniformOutput', false);
    y_pred_kruskal2_linear = cell2mat(y_pred_kruskal2') + Z_test * bl_rk2;

    %calculate metrics
    m1 = classification_metric(y_test_logistic', double(y_pred_kruskal2_logistic'), prob_kruskal2);
    m2 = poisson_metric(y_test_poisson', double(y_pred_kruskal2_poisson'));
    m3 = linear_metric(y_test_linear', double(y_pred_kruskal2_linear'));
    metric_kruskal2_logistic(fold, :) = cell2mat(struct2cell(m1));
    metric_kruskal2_poisson(fold, :) = m2;
    metric_kruskal2_linear(fold, :) = m3;
end

%% calculate the average of five folds
RMR_LOGISTIC = mean(metric_rmr_logistic, 1);
RMR_POISSON = mean(metric_rmr_poisson, 1);
RMR_LINEAR = mean(metric_rmr_linear, 1);
TUCKER12_LOGISTIC = mean(metric_tucker12_logistic, 1);
TUCKER12_POISSON = mean(metric_tucker12_poisson, 1);
TUCKER12_LINEAR = mean(metric_tucker12_linear, 1);
TUCKER22_LOGISTIC = mean(metric_tucker22_logistic, 1);
TUCKER22_POISSON = mean(metric_tucker22_poisson, 1);
TUCKER22_LINEAR = mean(metric_tucker22_linear, 1);
KRUSKAL1_LOGISTIC = mean(metric_kruskal1_logistic, 1);
KRUSKAL1_POISSON = mean(metric_kruskal1_poisson, 1);
KRUSKAL1_LINEAR = mean(metric_kruskal1_linear, 1);
KRUSKAL2_LOGISTIC = mean(metric_kruskal2_logistic, 1);
KRUSKAL2_POISSON = mean(metric_kruskal2_poisson, 1);
KRUSKAL2_LINEAR = mean(metric_kruskal2_linear, 1);
end