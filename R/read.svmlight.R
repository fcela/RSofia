read.svmlight <- function(file, ndim) {

  x <- .Call("svmlight_reader", file, ndim, PACKAGE = "RSofia")
  return (x)

}
