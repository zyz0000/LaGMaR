setwd("/home/zhangyz/mvglm")
library(stringr)
source("./simulation.R")
set.seed(2022)
REPS <- 100

#M_B_C_D_E命名规则
#M:METRIC的首字母
#B,C代表p1,p2的不同组合,(B,C)=(20,20), (20,50), (50,50)
#D代表样本量,1代表n=0.5p1p2,2代表n=p1p2,3代表n=1.5p1p2,4代表n=2p1p2
#E代表模型,L表示logistic,P代表poisson,O代表linear

M_20_20_1_L <- M_20_20_2_L <- M_20_20_3_L <- M_20_20_4_L <- 
  M_20_50_1_L <- M_20_50_2_L <- M_20_50_3_L <- M_20_50_4_L <- 
  M_50_50_1_L <- M_50_50_2_L <- M_50_50_3_L <- M_50_50_4_L <- matrix(0, REPS, 5)

M_20_20_1_P <- M_20_20_2_P <- M_20_20_3_P <- M_20_20_4_P <- 
  M_20_50_1_P <- M_20_50_2_P <- M_20_50_3_P <- M_20_50_4_P <- 
  M_50_50_1_P <- M_50_50_2_P <- M_50_50_3_P <- M_50_50_4_P <- matrix(0, REPS, 3)

M_20_20_1_O <- M_20_20_2_O <- M_20_20_3_O <- M_20_20_4_O <- 
  M_20_50_1_O <- M_20_50_2_O <- M_20_50_3_O <- M_20_50_4_O <- 
  M_50_50_1_O <- M_50_50_2_O <- M_50_50_3_O <- M_50_50_4_O <- matrix(0, REPS, 2)

k <- r <- 3
p1 <- q1 <- p2 <- 20
q2 <- p3 <- q3 <- 50
R1 <- matrix(runif(p1 * k, -sqrt(p1), sqrt(p1)), nrow = p1, ncol = k)
C1 <- matrix(runif(q1 * r, -sqrt(q1), sqrt(q1)), nrow = q1, ncol = r)
R2 <- matrix(runif(p2 * k, -sqrt(p2), sqrt(p2)), nrow = p2, ncol = k)
C2 <- matrix(runif(q2 * r, -sqrt(q2), sqrt(q2)), nrow = q2, ncol = r)
R3 <- matrix(runif(p3 * k, -sqrt(p3), sqrt(p3)), nrow = p3, ncol = k)
C3 <- matrix(runif(q3 * r, -sqrt(q3), sqrt(q3)), nrow = q3, ncol = r)

for (rep in 1:REPS){
  if ( rep %% 10 == 0 ){
    cat("This is the", rep, "th repetition...\n")
  }
  
  tryCatch(
    {
      M1 <- simulation(R1, C1, 0.5, 20, 20)
      M2 <- simulation(R1, C1, 1, 20, 20)
      M3 <- simulation(R1, C1, 1.5, 20, 20)
      M4 <- simulation(R1, C1, 2, 20, 20)
      
      M5 <- simulation(R2, C2, 0.5, 20, 50)
      M6 <- simulation(R2, C2, 1, 20, 50)
      M7 <- simulation(R2, C2, 1.5, 20, 50)
      M8 <- simulation(R2, C2, 2, 20, 50)
      
      M9 <- simulation(R3, C3, 0.5, 50, 50)
      M10 <- simulation(R3, C3, 1, 50, 50)
      M11 <- simulation(R3, C3, 1.5, 50, 50)
      M12 <- simulation(R3, C3, 2, 50, 50)
    }, error=function (e) {""}
  )

  #value assignment
  M_20_20_1_L[rep, ] <- M1$logistic
  M_20_20_2_L[rep, ] <- M2$logistic
  M_20_20_3_L[rep, ] <- M3$logistic
  M_20_20_4_L[rep, ] <- M4$logistic
  
  M_20_50_1_L[rep, ] <- M5$logistic
  M_20_50_2_L[rep, ] <- M6$logistic
  M_20_50_3_L[rep, ] <- M7$logistic
  M_20_50_4_L[rep, ] <- M8$logistic
  
  M_50_50_1_L[rep, ] <- M9$logistic
  M_50_50_2_L[rep, ] <- M10$logistic
  M_50_50_3_L[rep, ] <- M11$logistic
  M_50_50_4_L[rep, ] <- M12$logistic
  
  M_20_20_1_P[rep, ] <- M1$poisson
  M_20_20_2_P[rep, ] <- M2$poisson
  M_20_20_3_P[rep, ] <- M3$poisson
  M_20_20_4_P[rep, ] <- M4$poisson
  
  M_20_50_1_P[rep, ] <- M5$poisson
  M_20_50_2_P[rep, ] <- M6$poisson
  M_20_50_3_P[rep, ] <- M7$poisson
  M_20_50_4_P[rep, ] <- M8$poisson
  
  M_50_50_1_P[rep, ] <- M9$poisson
  M_50_50_2_P[rep, ] <- M10$poisson
  M_50_50_3_P[rep, ] <- M11$poisson
  M_50_50_4_P[rep, ] <- M12$poisson
  
  M_20_20_1_O[rep, ] <- M1$linear
  M_20_20_2_O[rep, ] <- M2$linear
  M_20_20_3_O[rep, ] <- M3$linear
  M_20_20_4_O[rep, ] <- M4$linear
  
  M_20_50_1_O[rep, ] <- M5$linear
  M_20_50_2_O[rep, ] <- M6$linear
  M_20_50_3_O[rep, ] <- M7$linear
  M_20_50_4_O[rep, ] <- M8$linear
  
  M_50_50_1_O[rep, ] <- M9$linear
  M_50_50_2_O[rep, ] <- M10$linear
  M_50_50_3_O[rep, ] <- M11$linear
  M_50_50_4_O[rep, ] <- M12$linear
}

all.vars <- data.frame(ls())
VARS <- as.character(all.vars[grep(pattern="M_", all.vars[,1]),])
for (item in 1:36){
  filename <- paste("./result/", VARS[item], ".csv", sep="")
  write.csv(get(VARS[item]), file=filename, row.names = FALSE)
}
                                   