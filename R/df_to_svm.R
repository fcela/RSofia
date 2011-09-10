df_to_svm <- function(formula, data, ...) {

  x <- (model.matrix(formula, data))
  x <- x[,-1] ### remove intercept
  response <- model.response(model.frame(formula, data))
  
  idx <- seq_len(ncol(x))
  svm_format <- vector("character", nrow(x))

  for(i in 1:nrow(x)) {
    data_row <- x[i,]
    data_row.mask <- (data_row != 0)    
    svm_format[i] <- paste(
      idx[data_row.mask]
      , data_row[data_row.mask]
      , sep = ":"
      , collapse = " "
    )    
  }
  
  svm_format <- paste(response, svm_format)
  
  return(svm_format)

}
