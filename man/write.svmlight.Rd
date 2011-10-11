\name{write.svmlight}
\alias{write.svmlight} 

\title{Write Files in SVM-Light Format} 

\description{
Write datasets in SVM-Light sparse data format
} 

\usage{write.svmlight(labels, data, no_bias_term, file, use_r_metadata = TRUE, \dots)} 

\arguments{

\item{labels}{numeric. labels for dataset}
\item{data}{numeric matrix. explanatory variables}
\item{file}{a character string giving the name of the file to be written to.}
\item{no_bias_term}{logical. should data include a bias term?}
\item{use_r_metadata}{logical. should R metadata be written to file?}
\item{\dots}{unused}

} 


\seealso{

\code{
  \link{read.svmlight}}
} 

\examples{

data(irismod)

x <- parse_formula(Is.Virginica ~ . , irismod)

tmp <- tempfile()
write.svmlight(x$labels, x$data, x$no_bias_term, tmp)
readLines(tmp)
unlink(tmp)
}
