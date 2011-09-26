\name{predict.sofia} 
\alias{predict.sofia} 

\title{Predict Method for Sofia-ml Model Fits} 

\description{

Predicted values based on Sofia-ml model object.

} 

\usage{ 

\method{predict}{sofia}(object, newdata, type = ifelse(object$par$learner_type \%in\% c("logreg-pegasos", "logreg"), "logistic", "linear"), \dots ) 
} 

\arguments{

\item{object}{sofia-ml object}
\item{newdata}{If the model was fit with \code{sofia.formula}, a data frame; if it was fit with \code{sofia.fit}, a
new set of X's}
\item{type}{\code{linear}: use standard linear dot product <w,x> for predictions;
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

\dontrun{
i.TRAIN <- sample(1:nrow(iris), 100)
model.logreg <- sofia(ifelse(Species=="setosa", 1, -1)~ ., data=iris[i.TRAIN,], learner_type="logreg")
p <- predict(model.logreg, newdata=iris[-1*i.TRAIN,])
table(predicted=p>0.5, actual=iris[-1*i.TRAIN,"Species"]=="setosa")

model.pegasos <- sofia(ifelse(Species=="setosa", 1, -1)~ ., data=iris[i.TRAIN,], learner_type="pegasos")
d <- predict(model.pegasos, newdata=iris[-1*i.TRAIN,])
table(predicted=d>0, actual=iris[-1*i.TRAIN,"Species"]=="setosa")
}
}
