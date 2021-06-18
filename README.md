### Code Document for **Factor Analysis for Matrix Variate GeneralizedLinear Models with Application to COVID-19 Image Data**

### Code Files

#### R files
| File        | Illustraion                          |
| :---------- | ----------------------------- |
| metrics.R     | different metrics to evaluate the model |
| data_generator.R      | generate simulated dataset           |
| simulation.R    | train and validate model using five-fold cross validation          |
| main.R | the main interface to perform simulation                |
| mvest.cpp| the implementation of FamGLM using RcppArmadillo|

To install the dependencies, you can run the following code in R console:
```R
depends <- c("stringr", "Rcpp", "RcppArmadillo", "caret", "ROCR")
for (pkg in depends){
    if (!require(pkg))
        install.packages(pkg)
}
```

#### matlab files
The matlab code is directly translated from R files.

| File        | Illustraion                          |
| :---------- | ----------------------------- |
| classification_metric.m     | calculate metrics for binary classification |
| linear_metric.m     | calculate metrics for linear regression           |
| poisson_metric.m    | calculate metrics for linear regression          |
| data_generator.m | generate simulated dataset in the same way with R code                |
| simulation.m | train and validate model using five-fold cross validation|
| main.m | the main interface to perform simulation                |

To install the dependencies, including [Tensor Toolbox](https://old-www.sandia.gov/~tgkolda/TensorToolbox/index-2.6.html), [TensorReg](https://hua-zhou.github.io/TensorReg/) and [SparseReg](https://github.com/Hua-Zhou/SparseReg/).
You should download and unzip them into the `toolbox` folder of your matlab installation location. Then add both path into the matlab search path by the following code:
```R
addpath(path) %<-- Add the toolbox to the Matlab path
save path %<-- Save for future Matlab sessions
```
