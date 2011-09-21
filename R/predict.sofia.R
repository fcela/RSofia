##############################################################
# object          : sofia object
# data            : data to test, of class svmlight
# prediction_type : "logistic" or "linear"
# no_bias_term    : logical "FALSE" by default
##############################################################

predict.sofia <- function(object, newdata, prediction_type, ...) {

  sofia_facade <- new(RSofiaFacade)

  x <- sofia_facade$predict(
         object$weights,
         newdata$data,
         object$par$no_bias_term,
         prediction_type
       )  

  return(x)

}
