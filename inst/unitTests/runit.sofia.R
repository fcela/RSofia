## ------------------------------------------------------------------------- ##
## Tests for setConfiguration                                                ##
##                                                                           ##
## @author fernando.cela-diaz@bankofamerica.com                              ##
## ------------------------------------------------------------------------- ##

cat("\n\nRUnit test cases for 'RSofia:::sofia' function\n\n")

# This function is executed at the end of the unit test
.tearDown <- function() {
  if (exists("track", envir=.GlobalEnv)) {
    rm(track, envir=.GlobalEnv)
  }
}

# Now the unit tests, following the naming convention test.XXX

test.sofia_pegasos <- function(){
  
  # Fit pegasos using sofia and known seed, compare output with that of a known out

}
