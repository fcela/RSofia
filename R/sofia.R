sofia <- function(x, ...) {
  UseMethod("sofia")
}

sofia.formula <- function(formula, data
  , random_seed = floor(runif(1, 1, 65535))
  , lambda = 0.1 
  , iterations = 100000
  , learner_type = c("pegasos", "sgd-svm", "passive-aggressive", "margin-perceptron", "romma", "logreg-pegasos") 
  , eta_type = c("pegasos", "basic", "constant") 
  , loop_type = c("stochastic", "balanced-stochastic", "rank", "roc", "query-norm-rank", "combined-ranking", "combined-roc")
  , rank_step_probability = 0.5
  , passive_aggressive_c = 10000000.0
  , passive_aggressive_lambda = 0
  , perceptron_margin_size = 1.0
  , training_objective = FALSE
  , hash_mask_bits = 0
  , verbose = FALSE
  , ...
) {

  ### need to replace with as.svmlight to eliminate duplicate code
  ### I think we should set no_bias_term permanately to FALSE and just have 
  ### the user provide the data with or without a column of ones
  
  learner_type <- match.arg(learner_type)
  loop_type <- match.arg(loop_type)
  eta_type <- match.arg(eta_type)
  
  parsed <- parse_formula(formula, data)

  dimensionality <- ifelse(parsed$no_bias_term, ncol(parsed$data), ncol(parsed$data)+1)
  
  sofia.model <-sofia.fit(parsed$data, parsed$labels, random_seed, lambda, iterations, learner_type, eta_type, loop_type, rank_step_probability 
    , passive_aggressive_c, passive_aggressive_lambda, perceptron_margin_size, training_objective
    , parsed$no_bias_term, dimensionality, hash_mask_bits, verbose
  )
  
  sofia.model$formula <- formula
                  
  return(sofia.model)
                  
}



sofia.fit <- function(x, y
  , random_seed = floor(runif(1, 1, 65535))
  , lambda = 0.1 
  , iterations = 100000
  , learner_type = "pegasos"
  , eta_type = "pegasos"
	, loop_type = "stochastic"
	, rank_step_probability = 0.5
  , passive_aggressive_c = 10000000.0
  , passive_aggressive_lambda = 0
  , perceptron_margin_size = 1.0
  , training_objective = FALSE
  , no_bias_term = FALSE
  , dimensionality = ncol(x)+ifelse(no_bias_term,0,1)
	, hash_mask_bits = 0
  , verbose = FALSE
  , ...
) {
  
  if (any(y!=1 & y!=-1)) warning("Labels with values other than {-1, +1} found in dataset")
                  
  sofia_facade <- new(RSofiaFacade)
  sofia_resultset <- sofia_facade$train(x, y
    , random_seed 
    , lambda 
    , iterations
    , learner_type 
    , eta_type
    , loop_type
  	, rank_step_probability
    , passive_aggressive_c
    , passive_aggressive_lambda
    , perceptron_margin_size
    , training_objective
    , dimensionality
  	, hash_mask_bits
  	, no_bias_term
    , verbose
  )

  weights       <- sofia_resultset$weights
  training_time <- sofia_resultset$training_time 
 
  obj <- list(
    par = list(random_seed=random_seed
                , lambda=lambda
                , iterations=iterations
                , learner_type=learner_type
                , eta_type=eta_type
                , loop_type=loop_type
                , rank_step_probability=rank_step_probability
                , passive_aggressive_c=passive_aggressive_c
                , passive_aggressive_lambda=passive_aggressive_lambda
                , perceptron_margin_size=perceptron_margin_size
                , training_objective=training_objective
                , dimensionality=dimensionality
              	, hash_mask_bits=hash_mask_bits
              	, no_bias_term=no_bias_term
                ),
    weights = weights
    , training_time = training_time
  )
 
  class(obj) <- "sofia"
  
  return (obj)

}



