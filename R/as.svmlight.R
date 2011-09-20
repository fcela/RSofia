as.svmlight <- function(formula, data) {

  mf <- model.frame(formula, data)
                  
  y <- mf[,1]
                          
  no_bias_term <- ifelse(attr(terms(formula, data=data), "intercept")==0, TRUE, FALSE)
  
  mm <- model.matrix(formula, mf) 

  x <- mm[, ifelse(no_bias_term, 1, 2):ncol(mm)]
                 
  res <- structure(list(data = x, labels = y), class = "svmlight")

  return (res) 

}
