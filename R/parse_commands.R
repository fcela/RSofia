parse_commands <- function(object, cmd_string, ...) {

  cmd_string.vector <- strsplit(cmd_string, " ")[[1]]
  object$RCommandLine(cmd_string.vector) 

}
