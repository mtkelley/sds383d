library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

tea <- read.csv("tea_discipline_oss.csv", stringsAsFactors = F)
tea <- tea[tea$ACTIONS > 0, ]

data <- list(N = nrow(tea), 
             intercept = rep(1, nrow(tea)),
             x = as.numeric(tea$GRADE), 
             y = tea$ACTIONS)

model <- stan(file = 'poisson.stan', data = data, chains = 4, iter = 1500)
names(model) <- c("Intercept", "Grade", "lp__")

print(model)
traceplot(model)
plot(model)

#Output
# Inference for Stan model: poisson.
# 4 chains, each with iter=1500; warmup=750; thin=1; 
# post-warmup draws per chain=750, total post-warmup draws=3000.
##mean se_mean   sd      2.5%       25%       50%       75%     97.5% n_eff Rhat
##Intercept      2.39    0.00 0.01      2.38      2.39      2.39      2.39      2.40   417 1.01
##Grade          0.05    0.00 0.00      0.05      0.05      0.05      0.05      0.05   463 1.01
##lp__      592385.80    0.05 1.01 592383.07 592385.40 592386.11 592386.52 592386.79   414 1.01

#Mult Obs
X <- as.matrix(data.frame(intercept = rep(1, nrow(tea)),
                          grade = as.numeric(tea$GRADE),
                          sex = as.numeric(tea$SEX == "MALE"),
                          hispanic = as.numeric(tea$ETHNICX == "Hispanic/Latino"),
                          black = as.numeric(tea$ETHNICX == "Black or African American"),
                          white = as.numeric(tea$ETHNICX == "White"),
                          attend = as.numeric(tea$SE_ATTEND)))
y <- tea$ACTIONS
data <- list(N = nrow(X), A = ncol(X), X = X, y = y)

model <- stan(file = 'poisson2.stan', data = data, chains = 4, iter = 1500)
names(model) <- c("Intercept", "Grade", "Male", "Black", "Hispanic", "White", "Attendance", "lp__")

# Output
# Inference for Stan model: poisson2.
# 4 chains, each with iter=1500; warmup=750; thin=1; 
# post-warmup draws per chain=750, total post-warmup draws=3000.
# 
# mean se_mean   sd      2.5%       25%       50%       75%     97.5% n_eff Rhat
# Intercept       1.49    0.00 0.02      1.45      1.48      1.49      1.50      1.53   581    1
# Grade           0.06    0.00 0.00      0.06      0.06      0.06      0.06      0.06  3000    1
# Male            0.21    0.00 0.00      0.21      0.21      0.21      0.22      0.22  2001    1
# Black           0.92    0.00 0.02      0.88      0.91      0.92      0.93      0.95   545    1
# Hispanic        0.89    0.00 0.02      0.85      0.88      0.89      0.90      0.92   545    1
# White           0.24    0.00 0.02      0.20      0.23      0.24      0.25      0.28   575    1
# Attendance     -0.59    0.00 0.00     -0.60     -0.60     -0.59     -0.59     -0.58  1784    1
# lp__       610094.62    0.06 1.87 610090.02 610093.57 610094.93 610096.01 610097.28  1009    1

print(model)
traceplot(model)
plot(model)