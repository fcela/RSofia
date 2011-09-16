\name{sofia} 

\alias{sofia} 

\title{ Fitting Model from sofia-ml - Suite of Fast Incremental Algorithms for Machine Learning } 

\description{
\code{sofia}.
} 

\usage{ load(file, envir = parent.frame()) } 
\usage{ second useage }

\arguments{

  \item{file}{a connection or a character string giving the name of the file to load.}
  \item{envir}{the environment where the data should be loaded.}

} 

\seealso{

\code{\link{save}}.
} 

\examples{ ## save all data save(list = ls(), file= "all.RData")
## restore the saved values to the current environment load("all.RData")
## restore the saved values to the workspace load("all.RData", .GlobalEnv) } \keyword{file}
