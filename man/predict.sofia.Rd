\name{predict.sofia} 

\alias{predict.sofia} 

\title{Read Files in SVM-Light Format} 

\description{

Read datasets in SVM-Light sparse data format:

<class-label> <feature-id>:<feature-value> ... <feature-id>:<feature-value>\n

<class-label> qid:<optional-query-id> <feature-id>:<feature-value> ... <feature-id>:<feature-value>\n

<class-label> <feature-id>:<feature-value> ... <feature-id>:<feature-value># Optional comment or extra data, following the optional "#" symbol.\n

} 

\usage{ read.svmlight(file) } 

\arguments{

\item{file}{a character string giving the name of the file to read.}

} 

\seealso{

\code{
  \link{write.svmlight}}
} 

\examples{

}
