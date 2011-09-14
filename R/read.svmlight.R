### ndim should probably be done automatically
### despite perf. cost

read.svmlight <- function(file, ndim) {

  x <- .Call("svmlight_reader", file, ndim, PACKAGE = "RSofia")
  
  #just a list with a class

  if(!is.character(x))
    class(x) <- "svmlight"

  return (x)

}
