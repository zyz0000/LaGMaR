data.generator <- function(Tc, p, q){
  k <- r <- 3
  Ts <- Tc * p * q
  
  R <- matrix(runif(p * k, -sqrt(p), sqrt(p)), nrow = p, ncol = k)
  C <- matrix(runif(q * r, -sqrt(q), sqrt(q)), nrow = q, ncol = r)
  X <- array(0, dim = c(p, q, Ts))
  y.linear <- y.logistic <- y.poisson <- rep(0, Ts)
  Zcov <- matrix(0, nrow=k*r, ncol=k*r)
  for (i in 1:(k*r)){
    Zcov[i, ] <- 0.5^abs((i - 1:(k*r)))
  }
  
  gamma <- 1
  alpha <- 2*c(1, -1, rep(0.5, floor((k*r - 2)/2)), rep(-0.5, k*r - 2 - floor((k*r - 2)/2)))

  for (i in 1:Ts){
    Z <- matrix(
      mvtnorm::rmvnorm(1, 
                         mean = rep(0, k * r), 
                         sigma = Zcov), 
      nrow = k, ncol = r
    )
    e <- matrix(rnorm(p * q), p, q)
    X[, , i] <- R %*% Z %*% t(C) + e
    y.linear[i] <- rnorm(1, mean=gamma + t(alpha) %*% matrix(Z, ncol = 1), sd=1)
    y.logistic[i] <- rbinom(1, 1, 1 / (1 + exp(-(gamma + t(alpha) %*% matrix(Z, ncol = 1)))))
    y.poisson[i] <- rpois(1, lambda=max(gamma + t(alpha) %*% matrix(Z, ncol=1), 1))
  }
  
  return (list(X=X, y.linear=y.linear, y.logistic=y.logistic, y.poisson=y.poisson))
}
