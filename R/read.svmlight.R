### ndim should probably be done automatically
### despite perf. cost

read.svmlight <- function(file) {

  x <- .Call("svmlight_reader", file, PACKAGE = "RSofia")
  
  #just a list with a class

  if(!is.character(x))
    class(x) <- "svmlight"

  return (x)

}
