\name{parse_formula} 
\alias{parse_formula} 
\title{parse a Dataframe for use with \code{"sofia.fit"}}

\description{
Function for parsing Dataframe for use with \code{"sofia.fit"}. 
} 

\usage{parse_formula(formula, data) } 

\arguments{
\item{formula}{an object of class \code{"formula"} }
\item{data}{a data frame}
} 

\value{\code{"parse_formula"} returns a list containing the following components:

\item{data}{a numeric matrix. The explanatory variables for the model}
\item{labels}{a numeric vector. The response variable}

}

\seealso{
\code{
} 
}

\examples{

data(irismod)
parse_formula(Is.Virginica ~ . , irismod)

}
