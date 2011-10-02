### ndim should probably be done automatically
### despite perf. cost

read.svmlight <- function(file, use_r_metadata = FALSE) {

  x <- .Call("svmlight_reader", file, use_r_metadata, PACKAGE = "RSofia")
  
  return (x)

}
