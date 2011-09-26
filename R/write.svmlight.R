write.svmlight <- function(labels, data, file, ...) {

  val <- .Call("svmlight_writer", file, data, labels, PACKAGE = "RSofia")

}
