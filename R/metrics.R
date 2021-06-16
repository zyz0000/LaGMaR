require(caret)
require(ROCR)
classification.metric <- function(y.true, y.pred, scores){
  if (!is.factor(y.true) || !is.factor(y.pred)){
    y.true <- as.factor(y.true)
    y.pred <- as.factor(y.pred)
  }
  confmat <- confusionMatrix(y.pred, y.true, positive = "1")
  m <- confmat$byClass
  pred <- prediction(scores, y.true)
  perf.auc <- performance(pred, measure = "auc")
  
  #c("Acc", "Kappa", "AUC", "Sensitivity", "F1")
  return (c(confmat$overall[1:2], unlist(perf.auc@y.values), m[1], m[7]))
}


linear.metric <- function(y.true, y.pred){
  RMSE <- sqrt(mean((y.pred - y.true)^2))
  MAE <- mean(abs(y.pred - y.true))
  return (c(RMSE, MAE))
}


poisson.metric <- function(y.true, y.pred){
  RMSE <- sqrt(mean((y.pred - y.true)^2))
  NMSE <- sum((y.pred - y.true)^2) / sum(y.true^2)
  MAE <- mean(abs(y.pred - y.true))
  return (c(RMSE, NMSE, MAE))
}
