\name{parse_formula} 
\alias{parse_formula} 
\title{Cast Dataframe into Object of Class "svmlight"} 

\description{
Function for casting a dataframe into an "svmlight" object.
} 

\usage{parse_formula(formula, data) } 

\arguments{
\item{formula}{an object of class \code{"formula"} }
\item{data}{a data frame}
} 

\value{\code{"parse_formula"} returns an object of class \code{"svmlight"}. An object of class \code{"svmlight"} is a list containing the following components:

\item{data}{a numeric matrix. The explanatory variables for the model}
\item{labels}{a numeric vector. The response variable (binary for classification, continuous for regression)}

}

\seealso{
\code{
} 
}

\examples{

data(irismod)
parse_formula(Is.Virginica ~ . , irismod)

}
