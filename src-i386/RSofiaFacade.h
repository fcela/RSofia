#ifndef R_SOFIA_FACADE_H
#define R_SOFIA_FACADE_H

#include <Rcpp.h>
#include "sf-data-set.h"
#include "sofia_cmd.h"

class RSofiaFacade {

  public:
    
    RSofiaFacade(); 
  
    std::vector<float> train(
        const Rcpp::NumericMatrix& x
      , const Rcpp::NumericVector& y
      , const long int random_seed
      , const float lambda
      , const long int iterations
      , const string& learner
      , const string& eta
      , const string& loop
      , const double rank_step_probability
      , const double passive_aggressive_c
      , const double passive_aggressive_lambda 
      , const double perceptron_margin_size
      , const bool training_objective 
      , const int dimensionality
      , const int hash_mask_bits
      , const bool no_bias_term
      , const bool verbose
    );
    
    std::vector<float> predict(
        const std::vector<float> weights 
      , const Rcpp::NumericMatrix& x
      , const string& prediction_type
    );


};

#endif
