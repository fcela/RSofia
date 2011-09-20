\name{read.svmlight} 

\alias{read.svmlight} 

\title{Read Files in SVM-Light Format} 

\description{

Read datasets in SVM-Light sparse data format:

\code{
<class-label> <feature-id>:<feature-value> ... <feature-id>:<feature-value>\\n
}

\code{
<class-label> qid:<optional-query-id> <feature-id>:<feature-value> ... <feature-id>:<feature-value>\\n
}

\code{
<class-label> <feature-id>:<feature-value> ... <feature-id>:<feature-value># Optional comment or extra data, following the optional "#" symbol.\\n
}

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

data(irismod)

irismod.svmlight <- as.svmlight(Is.Virginica ~ ., irismod)

tmp <- tempfile()
write.svmlight(irismod.svmlight, file = tmp)

irismod.svmlight2 <- read.svmlight(tmp)

unlink(tmp)

}
