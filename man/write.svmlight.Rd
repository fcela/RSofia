\name{write.svmlight}
\alias{write.svmlight} 

\title{Write Files in SVM-Light Format} 

\description{
Write datasets in SVM-Light sparse data format
} 

\usage{write.svmlight(labels, data, file, \dots)} 

\arguments{

\item{labels}{numeric. labels for dataset}
\item{data}{numeric matrix. explanatory variables}
\item{file}{a character string giving the name of the file to be written to.}
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

write.svmlight(x$labels, x$data, tmp); 

readLines(tmp)

unlink(tmp)

}
