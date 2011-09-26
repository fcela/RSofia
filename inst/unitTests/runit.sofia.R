## ------------------------------------------------------------------------- ##
## Tests for setConfiguration                                                ##
##                                                                           ##
## ------------------------------------------------------------------------- ##

cat("\n\nRUnit test cases for 'RSofia:::sofia' function\n\n")

# This function is executed at the end of the unit test
.tearDown <- function() {
  if (exists("track", envir=.GlobalEnv)) {
    rm(track, envir=.GlobalEnv)
  }
}

# Now the unit tests, following the naming convention test.XXX

# convention test.sofia.learner_type.loop_type

### load result data
data(sofia_ml_test_results)

### load training data
data(irismod)

TOLERANCE <- .0001
RANDOM_SEED <- 1L 

LEARNER_TYPE <- c( "pegasos", "sgd-svm", "passive-aggressive", "margin-perceptron", "romma", "logreg-pegasos" )
LOOP_TYPE <- c( "stochastic", "balanced-stochastic", "rank", "roc", "query-norm-rank", "combined-ranking", "combined-roc" )

test.sofia.pegasos.stochastic <- function() {
  
  LOOP_TYPE <- "stochastic"
  LEARNER_TYPE <- "pegasos"

  weights.RSofia <- sofia(Is.Virginica ~ ., irismod, random_seed = RANDOM_SEED
                          , learner_type = LEARNER_TYPE, loop_type = LOOP_TYPE)$weights

  weights.sofia_ml <- sofia_ml_test_results[[paste(LEARNER_TYPE, LOOP_TYPE, sep = "_")]]
 
  checkEqualsNumeric(weights.RSofia, weights.sofia_ml, msg = "Test Message", tolerance = TOLERANCE)

}

test.sofia.pegasos.balanced_stochastic <- function() {

  LOOP_TYPE <- "balanced-stochastic"
  LEARNER_TYPE <- "pegasos"

  weights.RSofia <- sofia(Is.Virginica ~ ., irismod, random_seed = RANDOM_SEED
                          , learner_type = LEARNER_TYPE, loop_type = LOOP_TYPE)$weights

  weights.sofia_ml <- sofia_ml_test_results[[paste(LEARNER_TYPE, LOOP_TYPE, sep = "_")]]
  
  checkEqualsNumeric(weights.RSofia, weights.sofia_ml, msg = "Test Message", tolerance = TOLERANCE)
 
}

test.sofia.pegasos.rank <- function() {
  
  LOOP_TYPE <- "rank"
  LEARNER_TYPE <- "pegasos"

  weights.RSofia <- sofia(Is.Virginica ~ ., irismod, random_seed = RANDOM_SEED
                          , learner_type = LEARNER_TYPE, loop_type = LOOP_TYPE)$weights

  weights.sofia_ml <- sofia_ml_test_results[[paste(LEARNER_TYPE, LOOP_TYPE, sep = "_")]]
 
  checkEqualsNumeric(weights.RSofia, weights.sofia_ml, msg = "Test Message", tolerance = TOLERANCE)

}
