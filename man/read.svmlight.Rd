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

\usage{ read.svmlight(file, use_r_metadata = FALSE) } 

\arguments{

\item{file}{a character string giving the name of the file to read.}
\item{use_r_metadata}{logical. Should file reader parse the two lines for information about variable names and bias_term?}

} 

\value{
\code{read.svmlight} returns a list eturns a list containing the following components:
  
  \item{data}{a numeric matrix. The explanatory variables for the model}
  \item{labels}{a numeric vector. The response variable}
  \item{no_bias_term}{\code{NULL} unless used in conjunction with \code{use_r_metadata = TRUE} and proper input file formatting}

}

\seealso{

\code{
  \link{write.svmlight}}
} 

\examples{

data(irismod)

x <- parse_formula(Is.Virginica ~ ., irismod)

tmp <- tempfile()
 
write.svmlight(x$labels, x$data, x$no_bias_term, use_r_metadata = TRUE, file = tmp)

irismod.svmlight.with_meta <- read.svmlight(tmp, use_r_metadata = TRUE)
irismod.svmlight.with_no_meta <- read.svmlight(tmp, use_r_metadata = FALSE)

unlink(tmp)

}
