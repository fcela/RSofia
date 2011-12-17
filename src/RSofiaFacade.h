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
#include "sf-weight-vector.h"
#include "sofia-ml-methods.h"
#include "sf-hash-weight-vector.h"
#include<ctime>

class RSofiaFacade {

  public:
    
  std::map<std::string, SEXP> train_filename(
       const std::string & filename
      , const long int random_seed
      , const float lambda
      , const long int iterations
      , const string& learner
      , const string& eta
      , const string& loop
      , const float rank_step_probability
      , const float passive_aggressive_c
      , const float passive_aggressive_lambda 
      , const float perceptron_margin_size
      , const bool training_objective 
      , const int dimensionality
      , const int hash_mask_bits
      , const bool no_bias_term
      , const bool verbose
      , const int buffer_mb 
    );
    
    std::map<std::string, SEXP> train_fit(
        const Rcpp::NumericMatrix& x
      , const Rcpp::NumericVector& y
      , const long int random_seed
      , const float lambda
      , const long int iterations
      , const string& learner
      , const string& eta
      , const string& loop
      , const float rank_step_probability
      , const float passive_aggressive_c
      , const float passive_aggressive_lambda 
      , const float perceptron_margin_size
      , const bool training_objective 
      , const int dimensionality
      , const int hash_mask_bits
      , const bool no_bias_term
      , const bool verbose
      , const int reserve
    );
    
    std::vector<float> predict(
        const Rcpp::NumericVector& weights
      , const Rcpp::NumericMatrix& newdata
      , const bool no_bias_term
      , const std::string& prediction_type
    );

  private:
    //these are to eliminate duplicate code
    SfWeightVector * alloc_SfWeightVector(int dimensionality, int hash_mask_bits);

    //alters eta_type
    void define_EtaType(sofia_ml::EtaType * eta_type
                                       , const std::string & eta);
    //alters learner_type, c, lambda_val
    void define_LearnerType(sofia_ml::LearnerType * learner_type
      , float * c 
      , float * lambda_val
      , const std::string & learner
      , const float perceptron_margin_size
      , const float passive_aggressive_c
      , const float passive_aggressive_lambda);
     
    void run_outer_loop(SfWeightVector * w
      , const std::string & loop
      , const SfDataSet & training_data
      , const sofia_ml::LearnerType & learner_type
      , const sofia_ml::EtaType & eta_type
      , const float lambda_val
      , const float c
      , const int iterations
      , const float rank_step_probability); 
                   
    std::map<std::string, SEXP> internal_train (
      const SfDataSet & training_data
      , const long int random_seed
      , const float lambda
      , const long int iterations
      , const std::string & learner
      , const std::string & eta
      , const std::string & loop
      , const float rank_step_probability
      , const float passive_aggressive_c
      , const float passive_aggressive_lambda
      , const float perceptron_margin_size
      , const bool training_objective
      , const int dimensionality
      , const int hash_mask_bits
      , const bool no_bias_term
      , const bool verbose //do we use this
    );

 
};

#endif
