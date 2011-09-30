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

# load test data

data(irismod)
data(sofia_ml_test)

# tests need not be as comprehensive as in sofia.fit

TOLERANCE <- .00001
RANDOM_SEED <- 1L

sofia.logreg_pegasos.stochastic.pegasos.nobias1 <- sofia(Is.Virginica ~ -1 + .
 , irismod, learner_type = "logreg-pegasos", loop_type = "stochastic"
 , eta_type = "pegasos", random_seed = RANDOM_SEED)

sofia.logreg_pegasos.stochastic.pegasos.nobias0 <- sofia(Is.Virginica ~ .
 , irismod, learner_type = "logreg-pegasos", loop_type = "stochastic"
 , eta_type = "pegasos", random_seed = RANDOM_SEED)

sofia.pegasos.stochastic.pegasos.nobias1 <- sofia(Is.Virginica ~ -1 + .
 , irismod, learner_type = "pegasos", loop_type = "stochastic"
 , eta_type = "pegasos", random_seed = RANDOM_SEED)

sofia.pegasos.stochastic.pegasos.nobias0 <- sofia(Is.Virginica ~ .
 , irismod, learner_type = "pegasos", loop_type = "stochastic"
 , eta_type = "pegasos", random_seed = RANDOM_SEED)

test.predict.sofia <- function() {

  #w bias
  checkEqualsNumeric(
    predict(
      sofia.pegasos.stochastic.pegasos.nobias1, irismod, prediction_type = "linear"
    ),
    sofia_ml_test[["pegasos_stochastic_pegasos_nobias1_linear"]],
    tolerance = TOLERANCE
  )
  
  checkEqualsNumeric(
    predict(
      sofia.pegasos.stochastic.pegasos.nobias0, irismod, prediction_type = "linear"
    ),
    sofia_ml_test[["pegasos_stochastic_pegasos_nobias0_linear"]],
    tolerance = TOLERANCE
  )
  
  checkEqualsNumeric(
    predict(
      sofia.logreg_pegasos.stochastic.pegasos.nobias1, irismod, prediction_type = "logistic"
    ),
    sofia_ml_test[["logreg-pegasos_stochastic_pegasos_nobias1_logistic"]],
    tolerance = TOLERANCE
  )
  
  checkEqualsNumeric(
    predict(
      sofia.logreg_pegasos.stochastic.pegasos.nobias0, irismod, prediction_type = "logistic"
    ),
    sofia_ml_test[["logreg-pegasos_stochastic_pegasos_nobias0_logistic"]],
    tolerance = TOLERANCE
  )
    
}


