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

\details{
  I don't believe this implementation of \code{"read.svmlight"} to be particularly robust and should be used with caution.
}

\usage{ read.svmlight(file) } 

\arguments{

\item{file}{a character string giving the name of the file to read.}

} 

\value{
\code{read.svmlight} returns a list containing the following components:
  
  \item{data}{a numeric matrix. The explanatory variables for the model}
  \item{labels}{a numeric vector. The response variable}
  \item{no_bias_term}{\code{NULL} } 

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

irismod.svmlight <- read.svmlight(tmp)

unlink(tmp)

}
