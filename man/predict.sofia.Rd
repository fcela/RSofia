\name{predict.sofia} 
\alias{predict.sofia} 

\title{Predict Method for Sofia-ml Model Fits} 

\description{

Predicted values based on Sofia-ml model object.

} 

\usage{ 

\method{predict}{sofia}(object, newdata, prediction_type, \dots ) 

} 

\arguments{

\item{object}{sofia-ml object}
\item{newdata}{A data frame in which to look for variables with which to predict.}
\item{prediction_type}{a character string. Options are \code{"linear"} for regression models and \code{"logistic"} for classification models.}
\item{\dots}{unused}

} 

\value{\code{"predict.sofia"} produces a numeric vector of predictions }

\seealso{

\code{
  \link{sofia}
}

} 

\examples{

data(irismod.svmlight)
model <- sofia(irismod.svmlight)
predict(model, irismod.svmlight, "logistic")

}
