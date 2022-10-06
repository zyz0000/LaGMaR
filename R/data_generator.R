data.generator <- function(R, C, Tc, p, q){
  k <- 3
  r <- 3
  Ts <- Tc * p * q
  X <- array(0, dim = c(p, q, Ts))
  v <- matrix(
    mvtnorm::rmvnorm(Ts, 
                     mean=rep(0, 3), 
                     sigma = diag(3)), 
    nrow=Ts, ncol=3
    )
  y.linear <- y.logistic <- y.poisson <- rep(0, Ts)
  Zcov <- matrix(0, nrow=k*r, ncol=k*r)
  for (i in 1:(k*r)){
    Zcov[i, ] <- 0.5^abs((i - 1:(k*r)))
  }
  gamma <- 1
  alpha <- 2*c(1, -1, rep(0.5, floor((k*r - 2)/2)), rep(-0.5, k*r - 2 - floor((k*r - 2)/2)))
  beta <- c(1, 1, 1)

  for (i in 1:Ts){
    Z <- matrix(
      mvtnorm::rmvnorm(1, 
                         mean = rep(0, k * r), 
                         sigma = Zcov), 
      nrow = k, ncol = r
    )
    e <- matrix(rnorm(p * q), p, q)
    X[, , i] <- R %*% Z %*% t(C) + e
    mu <- gamma + t(alpha) %*% matrix(Z, ncol = 1) + v[i, ] %*% beta
    y.linear[i] <- rnorm(1, mean=mu, sd=1)
    y.logistic[i] <- rbinom(1, 1, 1 / (1 + exp(-mu)))
    y.poisson[i] <- rpois(1, lambda=max(mu, 1))
  }
  
  return (list(X=X, v=v, y.linear=y.linear, y.logistic=y.logistic, y.poisson=y.poisson))
}
