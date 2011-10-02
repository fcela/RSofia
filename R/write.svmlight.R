write.svmlight <- function(labels, data, no_bias_term, file, use_r_metadata = TRUE, ...) {

  val <- .Call("svmlight_writer", file, data, labels, no_bias_term, use_r_metadata, PACKAGE = "RSofia")

}
