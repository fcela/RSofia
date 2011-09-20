library(RSofia)

models_dir <- "../SofiaModels/"

model_names   <- list.files(models_dir)
models        <- vector("list", length(model_names))
names(models) <- model_names 

for(i in 1:length(model_names)) {
  models[[i]] <- scan(paste(models_dir, model_names[i], sep="/"), what = double(), quiet = TRUE)
}

RANDOM_SEED  <- 1L
LEARNER_TYPE <- c( "pegasos", "sgd-svm", "passive-aggressive",
                   "margin-perceptron", "romma", "logreg-pegasos" )
LOOP_TYPE    <- c( "stochastic", "balanced-stochastic", "rank", "roc",
                   "query-norm-rank", "combined-ranking", "combined-roc" )

data_dir <- "../testData/"

data.svmlight <- read.svmlight(paste(data_dir, "irismod.svmlight", sep = ""))
models.R <- vector("list", length(model_names))

k <- 1

for(i in seq_along(LEARNER_TYPE)) {
  for(j in seq_along(LOOP_TYPE)) {
    models.R[[k]] <- sofia(data.svmlight, random_seed = RANDOM_SEED
                           , learner_type = LEARNER_TYPE[i], loop_type = LOOP_TYPE[j] )$weights 
    names(models.R)[k] <- paste(LEARNER_TYPE[i],"_",LOOP_TYPE[j],".out", sep = "")
    k <- k+1
  }
}


models.R <- models.R[order(names(models.R))]
models <- models[order(names(models))]

if(!all.equal(names(models.R), names(models)))
  stop("models do not align")

cat("do models match?\n")
all(all.equal(models.R, models, tolerance = 1e-5))
