library(Rcpp)
library(RcppArmadillo)
source("/home/zhangyz/mvglm/data_generator.R")
source("/home/zhangyz/mvglm/metrics.R")
sourceCpp(file="/home/zhangyz/mvglm/mvest.cpp")
simulation <- function(R, C, Tc, p, q){
  
  data <- data.generator(R, C, Tc, p, q)
  X <- data$X
  V <- data$v
  y.linear <- data$y.linear
  y.logistic <- data$y.logistic
  y.poisson <- data$y.poisson
  
  trainIndex <- createDataPartition(y.logistic, times = 5, p = 0.8, list = FALSE)
  metric.logistic <- matrix(0, nrow=5, ncol=5)
  metric.linear <- matrix(0, nrow=5, ncol=2)
  metric.poisson <- matrix(0, nrow=5, ncol=3)
  
  ## start five-fold cross validation
  for (fold in 1:5){
    idx <- trainIndex[, fold]
    X.train <- X[, , idx]
    X.val <- X[, , -idx]
    y.linear.train <- y.linear[idx]
    y.logistic.train <- y.logistic[idx]
    y.poisson.train <- y.poisson[idx]
    y.linear.val <- y.linear[-idx]
    y.logistic.val <- y.logistic[-idx]
    y.poisson.val <- y.poisson[-idx]
    V.train <- V[idx, ]
    V.val <- V[-idx, ]
    
    mvest.train <- mvest(X.train)
    Zhat <- mvest.train$Zhat
    Rhat <- mvest.train$Rhat
    Chat <- mvest.train$Chat
    
    Z.train.flatten <- matrix(aperm(Zhat, c(3, 1, 2)), nrow = dim(Zhat)[3])
    
    trainset.linear <- data.frame(cbind(y.linear.train, V.train, Z.train.flatten))
    trainset.logistic <- data.frame(cbind(y.logistic.train, V.train, Z.train.flatten))
    trainset.poisson <- data.frame(cbind(y.poisson.train, V.train, Z.train.flatten))
    
    colnames(trainset.linear) <- c("y", paste("V", c(1:(ncol(trainset.linear)-1)), sep=""))
    colnames(trainset.logistic) <- c("y", paste("V", c(1:(ncol(trainset.logistic)-1)), sep=""))
    colnames(trainset.poisson) <- c("y", paste("V", c(1:(ncol(trainset.poisson)-1)), sep=""))
    
    logit <- glm(y~., data=trainset.logistic, 
                 family=binomial(link="logit"), control=list(maxit=100))
    linear <- lm(y~., data = trainset.linear)
    poisson <- glm(y~., data=trainset.poisson, 
                   family=poisson(link="log"), control=list(maxit=100))
    
    Z.val <- t(apply(X.val, 3, function(x) t(Rhat) %*% x %*% Chat) / (p * q))
    Z.val <- cbind(V.val, Z.val)
    colnames(Z.val) <- c(paste("V", c(1:ncol(Z.val)), sep=""))
    Z.val <- data.frame(Z.val)
    
    logit.pred <- predict(logit, Z.val, type="link")
    logit.pred.prob <- 1 / (1 + exp(-logit.pred))
    logit.pred.class <- as.factor(as.numeric(predict
                                             (logit, Z.val, type="response") >= 0.5))
    linear.pred <- predict(linear, Z.val, type="response")
    poisson.pred <- predict(poisson, Z.val, type="response")
    
    metric.logistic[fold, ] <- classification.metric(y.logistic.val, 
                                                     logit.pred.class, logit.pred.prob)
    metric.poisson[fold, ] <- poisson.metric(y.poisson.val, poisson.pred)
    metric.linear[fold, ] <- linear.metric(y.linear.val, linear.pred)
  }
  
  
  LOGISTIC <- apply(metric.logistic, 2, mean)
  POISSON <- apply(metric.poisson, 2, mean)
  LINEAR <- apply(metric.linear, 2, mean)
  
  return (list(logistic=LOGISTIC, poisson=POISSON, linear=LINEAR))
}
