\name{as.svmlight} 
\alias{as.svmlight} 
\title{Cast Dataframe into Object of Class "svmlight"} 

\description{
Function for casting a dataframe into an "svmlight" object.
} 

\usage{as.svmlight(formula, data) } 

\arguments{
\item{formula}{an object of class \code{"formula"} }
\item{data}{a data frame}
} 

\value{\code{"as.svmlight"} returns an object of class \code{"svmlight"}. An object of class \code{"svmlight"} is a list containing the following components:

\item{data}{a numeric matrix. The explanatory variables for the model}
\item{labels}{a numeric vector. The response variable (binary for classification, continuous for regression)}

}

\seealso{
\code{
} 
}

\examples{

data(irismod)
as.svmlight(Is.Virginica ~ . , irismod)

}
