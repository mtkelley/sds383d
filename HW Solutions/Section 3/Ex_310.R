library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

tea <- read.csv("tea_discipline_oss.csv", stringsAsFactors = F)
tea <- tea[tea$ACTIONS > 0, ]

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

model <- stan(file = 'poisson2_imp.stan', data = data, chains = 4, iter = 1500)
#names(model) <- c("Intercept", "Grade", "Male", "Black", "Hispanic", "White", "Attendance", "lp__")


#print(model)
traceplot(model)
plot(model)
library(R.matlab)
ma_of_model = as.matrix(model)
writeMat("params_310.mat",params310=ma_of_model)
writeMat("X_310.mat",X=X)