## ------------------------------------------------------------------------- ##
## Tests for setConfiguration                                                ##
##                                                                           ##
## ------------------------------------------------------------------------- ##

cat("\n\nRUnit test cases for 'RSofia:::sofia' function\n\n")

# This function is executed at the end of the unit test
#.tearDown <- function() {
#  if (exists("track", envir=.GlobalEnv)) {
#    rm(track, envir=.GlobalEnv)
#  }
#}

# Now the unit tests, following the naming convention test.XXX

# convention test.sofia.learner_type.loop_type

### load result data

data(irismod)
data(sofia_ml_test_results)

RANDOM_SEED <- 1L
TOLERANCE <- .00001

LEARNER_TYPE <- c( "pegasos", "sgd-svm", "passive-aggressive", "margin-perceptron", "romma", "logreg-pegasos" )
LOOP_TYPE    <- c( "stochastic", "balanced-stochastic", "rank", "roc", "query-norm-rank", "combined-ranking", "combined-roc" )
ETA_TYPE     <- c( "pegasos", "basic", "constant" )
NO_BIAS_TERM <- c( TRUE, FALSE)

create_function_text <- function(learner, loop, eta, no_bias_term) {

  function_txt.name <- paste("test.sofia."
    , gsub("-","_",learner),"."
    , gsub("-","_",loop), "."
    , gsub("-","_",eta), "."
    , paste("bias", as.integer(no_bias_term),sep=""), " <- function()"
    , " { \n", sep ="")

  function_txt.body <- paste(
      
      "  weights.RSofia <- sofia(Is.Virginica ~", ifelse(no_bias_term, "-1 +", ""),
      " ., irismod, random_seed = RANDOM_SEED", "\n",
      "  ,eta_type = '", eta,
      "'  ,learner_type ='", learner,
      "'  ,loop_type = '", loop,
      "'", 
      "  )$weights", "\n\n",
      "  weights.sofia_ml <- sofia_ml_test_results[[\'",
         paste(learner, loop, eta, paste("bias", as.integer(no_bias_term),sep=""), sep = '_'),
         "\']]","\n\n",
      "  checkEqualsNumeric(weights.RSofia, weights.sofia_ml, tolerance = TOLERANCE)", sep = "")
                      
  function_txt.end <- "\n}"
                        
  function_txt <- paste(function_txt.name, function_txt.body, function_txt.end, sep = "\n")
                        
  return(function_txt)

}

for(i in LEARNER_TYPE)
  for(j in LOOP_TYPE)
    for(k in ETA_TYPE)
      for(l in NO_BIAS_TERM)
        eval(parse(text = create_function_text(i,j,k,l)))()
