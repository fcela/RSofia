### fits model
### make generic

sofia <- function(x, data, ...) {
  UseMethod("sofia")
}
#naming is bad, i know
sofia.svmlight <- function(x, data = NULL
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
	, hash_mask_bits = 0
  , verbose = FALSE
) 

{

   ### still not sure how to treat the error term...

   y <- x$labels
   x <- x$data

   dimensionality <- ncol(x)

   no_bias_term <- TRUE ### for now
 
   return(
      sofia.fit(x, y, random_seed, lambda, iterations, learner_type, eta_type, loop_type, rank_step_probability
      , passive_aggressive_c, passive_aggressive_lambda, perceptron_margin_size, training_objective
      , no_bias_term, dimensionality, hash_mask_bits, verbose
     ) 
   )
}
 

sofia.formula <- function(x, data
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
	, hash_mask_bits = 0
  , verbose = FALSE
) {
  
  mf <- model.frame(formula, data)
                  
  y <- mf[,1]
                          
  no_bias_term <- ifelse(attr(terms(formula), "intercept")==0, TRUE, FALSE)
  mm <- model.matrix(formula, mf) 

  x <- mm[, ifelse(no_bias_term, 1, 2):ncol(mm)]
  dimensionality <- ifelse(no_bias_term, ncol(x), ncol(x)+1)
                  
  return(
    sofia.fit(x, y, random_seed, lambda, iterations, learner_type, eta_type, loop_type, rank_step_probability 
    , passive_aggressive_c, passive_aggressive_lambda, perceptron_margin_size, training_objective
    , no_bias_term, dimensionality, hash_mask_bits, verbose
    )
  )
                  
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
) {
                  
  sofia_facade <- new(RSofiaFacade)
  weights <- sofia_facade$train(x, y
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
              	, no_bias_term=no_bias_term),
    weights = weights
  )
 
  class(obj) <- "sofia"
  
  return (obj)

}
