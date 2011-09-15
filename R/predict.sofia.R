##############################################################
# object          : sofia object
# data            : data to test, this is tricky with matrices
# prediction_type : "logistic" or "linear"
# no_bias_term    : logical "FALSE" by default
##############################################################

predict.sofia <- function(object, data, prediction_type) {

  sofia_facade <- new(RSofiaFacade)

  x <- sofia_facade$predict(
         object$weights,
         data,
         object$par$no_bias_term,
         prediction_type
       )  

  return(x)

}
