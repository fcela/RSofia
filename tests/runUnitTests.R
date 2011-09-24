## ------------------------------------------------------------------------- ##
## runUnitTests.R                                                            ##
## ------------------------------------------------------------------------- ##

## ------------------------------------------------------------------------- ##
#'
#' Script to run unit tests during package building
#' Assumes a directory called "unitTests" exists under "inst"

if(require("RUnit", quietly = TRUE)) {

  ## --- Setup ---

  wd <- getwd()
  pkg <- sub("\\.Rcheck$", '', basename(dirname(wd)))

  library(package=pkg, character.only = TRUE)

  path <- system.file("unitTests", package = pkg)

  stopifnot(file.exists(path), file.info(path.expand(path))$isdir)

  source(file.path(path, "runTests.R"), echo = TRUE)

} else {
  stop("Can't run unit tests -- is RUnit installed?")  
}
