function [metrics] = classification_metric(y_true, y_pred, scores)
    % compute metrics in binary classification
    % y_true: the true label
    % y_pred: the predicted label
    % scores: \hat{P}(Y=1) obtained from logistic classifier
    
    % confusion matrix
    [A, ~] = confusionmat(y_true, y_pred);
    
    % accuracy
    acc = mean(y_true == y_pred);
    
    % precision
    precision = A(2, 2) / (A(2, 2) + A(1, 2));
    % recall
    recall = A(2, 2) / (A(2, 2) + A(2, 1));
    % F1
    F1 = 2 * precision * recall / (precision + recall);
    
    % sensitivity
    sensitivity = recall;
    
    % kappa
    n = sum(A(:));
    sum_po = 0;
    sum_pe = 0;
    p = size(A);
    for i = 1:p
        sum_po = sum_po + A(i, i);
        row = sum(A(i, :));
        col = sum(A(:, i));
        sum_pe = sum_pe + row * col;
    end
    po = sum_po / n;
    pe = sum_pe / (n * n);
    kappa = (po - pe) / (1 - pe);
    
    %AUC
    [~, ~, ~, AUC] = perfcurve(y_true, scores, "1");
    
    % metrics
    metrics = struct('accuracy', acc, ...
            'kappa', kappa, ...
            'AUC', AUC, ...
            'sensitivity', sensitivity, ...
            'F1', F1);
end

