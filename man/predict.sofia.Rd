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
\item{newdata}{If the model was fit with \code{sofia.formula}, a data frame; if it was fit with \code{sofia.fit}, a
new set of X's}
\item{prediction_type}{\code{linear}: use standard linear dot product <w,x> for predictions;
\code{logistic}: use prediction function of exp(<w,x>) / (1 + exp(<w,x>)) for prediction, in the manner of logistic regression}
\item{\dots}{unused}

} 

\value{\code{predict.sofia} produces a numeric vector of predictions }

\seealso{

\code{
  \link{sofia}
}

} 

\examples{

data(irismod)
i.TRAIN <- sample(1:nrow(irismod), 100)

model.logreg <- sofia(Is.Virginica ~ ., data=irismod[i.TRAIN,], learner_type="logreg-pegasos")
p <- predict(model.logreg, newdata=irismod[-1*i.TRAIN,], prediction_type = "logistic")
table(predicted=p>0.5, actual=irismod[-1*i.TRAIN,]$Is.Virginica)

model.pegasos <- sofia(Is.Virginica ~ ., data=irismod[i.TRAIN,], learner_type="pegasos")
d <- predict(model.pegasos, newdata=irismod[-1*i.TRAIN,], prediction_type = "linear")
table(predicted=d>0, actual=irismod[-1*i.TRAIN,]$Is.Virginica)

}
