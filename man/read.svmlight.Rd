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

\value{
\code{read.svmlight} returns a list eturns a list containing the following components:
  
  \item{data}{a numeric matrix. The explanatory variables for the model}
  \item{labels}{a numeric vector. The response variable}

}

\seealso{

\code{
  \link{write.svmlight}}
} 

\examples{

data(irismod)

x <- parse_formula(Is.Virginica ~ ., irismod)

tmp <- tempfile()
 
write.svmlight(x$labels, x$data, file = tmp)

irismod.svmlight2 <- read.svmlight(tmp)

unlink(tmp)

}
