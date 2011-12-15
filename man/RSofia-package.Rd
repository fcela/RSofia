\name{RSofia-package}
\alias{RSofia-package}
\alias{RSofia}
\docType{package}
\title{
Train and Test Suite of Models from Sofia-ml
}
\description{
Sofia-ml is a suite of fast incremental algorithms for machine learning that can be used for training models for classification or ranking
}
\details{

\tabular{ll}{
Package: \tab RSofia\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2011-09-06\cr
License: \tab apache \cr
LazyLoad: \tab yes\cr
}

}
\author{
W. Michael King \email{wmichaelking1@gmail.com} and 

Fernando Cela Diaz \email{<fcela@sloan.mit.edu}. 

Original sofia-ml code by D. Sculley \email{dsculley@google.com}.

Maintainer: W. Michael King \email{wmichaelking1@gmail.com}
}
\references{

D. Sculley. \emph{Combined Regression and Ranking}. Proceedings of the 16th Annual SIGKDD Conference on Knowledge Discover and Data Mining, 2010.

D. Sculley. \emph{Web-Scale K-Means Clustering}. Proceedings of the 19th international conference on World Wide Web, 2010.

D. Sculley. \emph{Large Scale Learning to Rank}. NIPS Workshop on Advances in Ranking, 2009. Presents the indexed sampling methods used learning to rank, including the rank and roc loops.

K. Crammer, O. Dekel, J. Keshet, S. Shalev-Shwartz, and Y. Singer. \emph{Online passive-aggressive algorithms}. J. Mach. Learn. Res., 7, 2006. Presents the Passive-Aggressive Perceptron algorithm.

T. Joachims. \emph{Optimizing search engines using clickthrough data}. In KDD '02: Proceedings of the eighth ACM SIGKDD international conference on Knowledge discovery and data mining, 2002. Presents the RankSVM objective function, a pairwise objective function used by the rank loop method in sofia-ml.

Y. Li and P. M. Long. \emph{The relaxed online maximum margin algorithm}. Mach. Learn., 46(1-3), 2002. Presents the ROMMA algorithm.

S. Shalev-Shwartz, Y. Singer, and N. Srebro. Pegasos: \emph{Primal estimated sub-gradient solver for SVM}. In ICML '07: Proceedings of the 24th international conference on Machine learning, 2007. Presents the Pegasos SVM solver.

T. Zhang. \emph{Solving large scale linear prediction problems using stochastic gradient descent algorithms}. In ICML '04: Proceedings of the twenty-first international conference on Machine learning, 2004. Presents SGD SVM.

\url{http://leon.bottou.org/projects/sgd} Leon Bottou's SGD page, including experiments with SGD SVM.

W. Krauth and M. M'ezard. \emph{Learning algorithms with optimal stability in neural networks}. Journal of Physics A, 20(11):745-752, 1987. Presents Perceptron with Margins.


}
\keyword{ package }
