\name{sofia} 

\alias{sofia} 
\alias{sofia.character}
\alias{sofia.formula}
\alias{sofia.fit}

\title{Fitting sofia-ml models} 

\description{
\code{sofia} is used to fit classification and regression models provided by D. Sculley's sofia-ml.
} 

\usage{ sofia(x, \dots) 

\method{sofia}{formula}(x, data, random_seed = floor(runif(1, 1, 65535)), lambda = 0.1, 
    iterations = 1e+05, learner_type = c("pegasos", "sgd-svm", 
        "passive-aggressive", "margin-perceptron", "romma", "logreg-pegasos"), 
    eta_type = c("pegasos", "basic", "constant"), loop_type = c("stochastic", 
        "balanced-stochastic", "rank", "roc", "query-norm-rank", 
        "combined-ranking", "combined-roc"), rank_step_probability = 0.5, 
    passive_aggressive_c = 1e+07, passive_aggressive_lambda = 0, 
    perceptron_margin_size = 1, training_objective = FALSE, hash_mask_bits = 0, 
    verbose = FALSE, reserve = 0, \dots)

\method{sofia}{character}(x, random_seed = floor(runif(1, 1, 65535)), lambda = 0.1, 
    iterations = 1e+05, learner_type = c("pegasos", "sgd-svm", 
        "passive-aggressive", "margin-perceptron", "romma", "logreg-pegasos"), 
    eta_type = c("pegasos", "basic", "constant"), loop_type = c("stochastic", 
        "balanced-stochastic", "rank", "roc", "query-norm-rank", 
        "combined-ranking", "combined-roc"), rank_step_probability = 0.5, 
    passive_aggressive_c = 1e+07, passive_aggressive_lambda = 0, 
    perceptron_margin_size = 1, training_objective = FALSE,no_bias_term = FALSE, dimensionality=150000, hash_mask_bits = 0, 
    verbose = FALSE, buffer_mb = 40, \dots)
}

\arguments{

\item{x}{a \code{formula} object or a character with a path to a file}
\item{data}{data to parse formula on, when model is specified via a formula}
\item{random_seed}{an integer. Makes algorithm use this seed. Can be useful in testing and parameter tuning}
\item{lambda}{a numeric scalar. Value of lambda for SVM regularization, used by both Pegasos SVM and SGD-SVM.}
\item{iterations}{an integer. Number of stochastic gradient steps to take.}
\item{learner_type}{a character string indicating which type of learner to use. One of \code{"pegasos"} (default), \code{"sgd-svm"}, \code{"passive-aggressive"}, \code{"margin-perceptron"}, \code{"romma"}, \code{"logreg-pegasos"}}
\item{eta_type}{a character string indicating the type of update for learning rate to use. One of \code{"pegasos"} (default), \code{"basic"}, \code{"constant"}}
\item{loop_type}{a character string indicating the type of sampling loop to use for training. One of 

\code{"stochastic"} - Perform normal stochastic sampling for stochastic gradient descent, for training binary classifiers. On each iteration, pick a new example uniformly at random from the data set.

\code{"balanced-stochastic"} - Perform a balanced sampling from positives and negatives in data set. For each iteration, samples one positive example uniformly at random from the set of all positives, and samples one negative example uniformly at random from the set of all negatives. This can be useful for training binary classifiers with a minority-class distribution.

\code{"rank"} - Perform indexed sampling of candidate pairs for pairwise learning to rank. Useful when there are examples from several different qid groups.

\code{"roc"} - Perform indexed sampling to optimize ROC Area.

\code{"query-norm-rank"} - Perform sampling of candidate pairs, giving equal weight to each qid group regardless of its size. Currently this is implemented with rejection sampling rather than indexed sampling, so this may run more slowly.

\code{"combined-ranking"} - Performs CRR algorithm for combined regression and ranking. Alternates between pairwise rank-based steps and standard stochastic gradient steps on single examples. Relies on \code{"rank_step_probability"} to balance between these two kinds of updates.

\code{"combined-roc"} - Performs CRR algorithm for combined regression and ROC area optimization. Alternates between pairwise roc-optimization-based steps and standard stochastic gradient steps on single examples. Relies on \code{"rank_step_probability"} to balance between these two kinds of updates. This can be faster than the combined-ranking option when there are exactly two classes.
}
\item{rank_step_probability}{a numeric scalar. Probability that we will take a rank step (as opposed to a standard stochastic gradient step) in a combined ranking or combined ROC loop.}
\item{passive_aggressive_c}{a numeric scalar. Maximum size of any step taken in a single passive-aggressive update}
\item{passive_aggressive_lambda}{a numeric scalar. Lambda for pegasos-style projection for passive-aggressive update. When set to 0 (default) no projection is performed.}
\item{perceptron_margin_size}{Width of margin for perceptron with margins. Default of 1 is equivalent to unregularized SVM-loss}
\item{training_objective}{logical. When \code{TRUE}, computes the value of the standard SVM objective function on training data, after training.}
\item{dimensionality}{integer. Index id of largest feature index in training data set, plus one.}
\item{hash_mask_bits}{an integer. When set to a non-zero value, causes the use of a hased weight vector with hashed cross product features. This allows learning on conjunction of features, at some increase in computational cost. Note that this flag must be set both in training and testing to function properly. The size of the hash table is set to 2^\code{hash_mask_bits}. default value of 0 shows that hash cross products are not used.}
\item{verbose}{logical.}
\item{no_bias_term}{logical. When set, causes a bias term x_0 to be set to 0 for every feature vector loaded from files, rather than the default of x_0 = 1.
Setting this flag is equivalent to forcing a decision threshold of exactly 0 to be used.
The same setting of this flag should be used for training and testing.
Note that this flag as no effect for rank and roc optimzation.
Default: not set. To set this flag using the formula interface use ( Y ~ -1 + . )}
\item{reserve}{integer. experimental, should vector be explicity reserved for data?} 
\item{buffer_mb}{integer. Size of buffer to use in reading/writing to files, in MB.}
\item{\dots}{items passed to methods.}
} 

\details{}

\value{\code{sofia} returns an object of class "sofia".

An object of class "sofia" is a list containing at least the following components:

\item{par}{a list containing the parameters specified in training the model}
\item{weights}{a numeric vector of the parameter weights (the model) }
\item{training_time}{time used to fit the model (does not include io time) }

If the method was called via the formula interface, it will additionally include:

\item{formula}{formula with the specification of the model}

}


\references{

D. Sculley. \emph{Combined Regression and Ranking}. Proceedings of the 16th Annual SIGKDD Conference on Knowledge Discover and Data Mining, 2010.

D. Sculley. \emph{Web-Scale K-Means Clustering}. Proceedings of the 19th international conference on World Wide Web, 2010.

D. Sculley. \emph{Large Scale Learning to Rank}. NIPS Workshop on Advances in Ranking, 2009. Presents the indexed sampling methods used learning to rank, including the rank and roc loops.

}

\seealso{
\url{http://code.google.com/p/sofia-ml/}
} 

\examples{

data(irismod)

model.logreg <- sofia(Is.Virginica ~ ., data=irismod, learner_type="logreg-pegasos")

}
