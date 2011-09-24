

predict.sofia <- function(object, newdata
  , type = ifelse(object$par$learner_type %in% c("logreg-pegasos", "logreg"), "logistic", "linear")
  , ...
) {

  sofia_facade <- new(RSofiaFacade)
  
  # Check if data needs processing
  if (is.null(object$formula)) {
    p <- sofia_facade$predict(object$weights, newdata, object$par$no_bias_term, type)  
  } else {
    parsed <- parse_formula(object$formula, newdata)
    p <- sofia_facade$predict(object$weights, parsed$data, object$par$no_bias_term, type)
  }
    
  return(p)

}
