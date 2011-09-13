//================================================================================//
//                                                                                // 
// Licensed under the Apache License, Version 2.0 (the "License");                //
// you may not use this file except in compliance with the License.               //
// You may obtain a copy of the License at                                        //
//                                                                                //
//      http://www.apache.org/licenses/LICENSE-2.0                                //
//                                                                                //
// Unless required by applicable law or agreed to in writing, software            //
// distributed under the License is distributed on an "AS IS" BASIS,              //
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.       //
// See the License for the specific language governing permissions and            //
// limitations under the License.                                                 //
//================================================================================//
//
// RSofiaFacade.h
//
// Authors: Mike King <wmichaelking1@gmail.com>
//          Fernando Cela-Diaz <fcela@sloan.mit.edu>


#ifndef R_SOFIA_FACADE_H
#define R_SOFIA_FACADE_H

#include <Rcpp.h>
#include "sf-data-set.h"
#include "sofia_cmd.h"

class RSofiaFacade {

  public:
    
//    RSofiaFacade(); 
  
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
        const Rcpp::NumericVector& weights
      , const Rcpp::NumericMatrix& newdata
      , const bool no_bias_term
      , const std::string& prediction_type
    );

};

#endif
