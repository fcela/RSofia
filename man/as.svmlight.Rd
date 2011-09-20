\name{as.svmlight} 

\alias{as.svmlight} 

\title{cast dataframe into object of class "svmlight"} 

\description{

} 

\usage{ as.svmlight(formula, data) } 

\arguments{
\item{formula}{}
\item{data}{}
} 

\seealso{
\code{
} 
}

\examples{

data(irismod)
as.svmlight(Is.Virginica ~ . , irismod)

}
