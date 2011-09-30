parse_formula <- function(formula, data) {
  
  mf <- model.frame(formula, data)       
  y  <- model.response(mf, "numeric")                
  no_bias_term <- ifelse(attr(terms(formula, data=data), "intercept")==0, TRUE, FALSE)

  mm <- model.matrix(formula, data) 
  x <- mm[, colnames(mm)!="(Intercept)"]
  res <- list(data = x, labels = y, no_bias_term=no_bias_term)
  return (res)

}
