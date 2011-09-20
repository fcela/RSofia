write.svmlight <- function(x, file, ...) {

  if(class(x) != "svmlight")
    stop("x must be of class svmlight")

  val <- .Call("svmlight_writer", file, x$data, x$labels, PACKAGE = "RSofia")

  return (val)

}
