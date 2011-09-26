\name{write.svmlight}
\alias{write.svmlight} 

\title{Write Files in SVM-Light Format} 

\description{
Write datasets in SVM-Light sparse data format
} 

\usage{write.svmlight(x, file, \dots)} 

\arguments{

\item{x}{an object of class "svmlight"}
\item{file}{a character string giving the name of the file to be written to.}
\item{\dots}{unused}

} 

\value{
returns numeric "0" on success or a character string on failure.
}

\seealso{

\code{
  \link{read.svmlight}}
} 

\examples{

data(irismod.svmlight)
\dontrun{
tmp <- tempfile()
write.svmlight(irismod.svmlight, tmp)
### cleanup
unlink(tmp)
}
}
