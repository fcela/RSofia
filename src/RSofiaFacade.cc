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
// RSofiaFacade.cc
//
// Authors: Mike King <wmichaelking1@gmail.com>
//          Fernando Cela-Diaz <fcela@sloan.mit.edu>

#include "R.h"
#include "Rcpp.h"
#include "RSofiaFacade.h"

std::map<std::string, SEXP> RSofiaFacade::internal_train (
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
) 

{

  srand(random_seed);
  SfWeightVector * w  = alloc_SfWeightVector(dimensionality, hash_mask_bits); 
    
  clock_t train_start = std::clock();

  // Default values for c and lambda
  
  float c = 0.0;
  float lambda_val = lambda;
 
  int bad = 0;
  std::map<std::string, SEXP> rs;

  sofia_ml::EtaType eta_type;
  define_EtaType(&eta_type, eta);
   
 
  sofia_ml::LearnerType learner_type;

    // Define learner type
  define_LearnerType(&learner_type, &c, &lambda_val
                    ,learner, perceptron_margin_size, passive_aggressive_c, passive_aggressive_lambda); 

  // Run required outer loop
  run_outer_loop(w, loop, training_data, learner_type
                        ,eta_type, lambda_val, c, iterations, rank_step_probability); 

  clock_t train_end = std::clock();
  float time_elapsed = (train_end - train_start) / (float)CLOCKS_PER_SEC;

    // copy data from sfweightvector to result
  size_t n = w->GetDimensions();

  std::vector<float> weights(n);

  for(size_t i = 0; i < n; ++i)
    weights[i] = w->ValueOf(i);
  
  delete w;


  rs["weights"]       = Rcpp::wrap(weights);
  rs["training_time"] = Rcpp::wrap(time_elapsed); 

  return(rs);
    
}

std::map<std::string, SEXP> RSofiaFacade::train_filename (
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
) 

{

  clock_t t1 = std::clock();

  SfDataSet training_data(filename, buffer_mb, !no_bias_term);

  clock_t t2 = std::clock();

  std::map<std::string, SEXP> rs = internal_train(
    training_data
    , random_seed
    , lambda
    , iterations
    , learner
    , eta
    , loop
    , rank_step_probability
    , passive_aggressive_c
    , passive_aggressive_lambda
    , perceptron_margin_size
    , training_objective
    , dimensionality
    , hash_mask_bits
    , no_bias_term
    , verbose //do we use this
  );

  float io_time = (t2 - t1)/(float)CLOCKS_PER_SEC;

  rs["io_time"] = Rcpp::wrap(io_time);

  return rs;

}

std::map<std::string, SEXP> RSofiaFacade::train_fit (
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
) 

{
  /***  
  if(reserve == 0)  {
    SfDataSet training_data(!no_bias_term);
  } else {
    SfDataSet training_data(!no_bias_term, reserve);
  }***/
    
  SfDataSet training_data(!no_bias_term, reserve);

  std::stringstream out_stream;
  
  //read data into training data
 
  clock_t t1 = std::clock();
 
  for(int i = 0; i < x.nrow(); ++i) {
    out_stream << y[i];
    for(int j = 0; j < x.ncol(); ++j) { 
      if(x(i,j) != 0) {
        out_stream << " " << (j + 1) << ":" << x(i,j);
      }
    }
    training_data.AddVector(out_stream.str().c_str());
    out_stream.str("");        
  }

  clock_t t2 = std::clock();

  float io_time = (t2 - t1)/(float)CLOCKS_PER_SEC;

  std::map<std::string, SEXP> rs = internal_train(
    training_data
    , random_seed
    , lambda
    , iterations
    , learner
    , eta
    , loop
    , rank_step_probability
    , passive_aggressive_c
    , passive_aggressive_lambda
    , perceptron_margin_size
    , training_objective
    , dimensionality
    , hash_mask_bits
    , no_bias_term
    , verbose
  );

  rs["io_time"] = Rcpp::wrap(io_time);
  return rs;

}

 
std::vector<float> RSofiaFacade::predict(
  const Rcpp::NumericVector& weights, 
  const Rcpp::NumericMatrix& newdata, 
  const bool no_bias_term,
  const std::string & prediction_type) 

{
    // Import data into a SfDataSet structure
  SfDataSet test_data = SfDataSet(!no_bias_term);
  
   // pre-increment is better

  std::stringstream out_stream;
     
  for(size_t i = 0 ; i < newdata.nrow(); ++i) {
     //i see now, this value is irrelevant
    out_stream << 0; 
        
    for(int j = 0; j < newdata.ncol(); ++j) {
      if(newdata(i,j) != 0) {
        out_stream << " " << (j+1) << ":" << newdata(i,j);
      }
    }
    test_data.AddVector(out_stream.str());
    out_stream.str(""); 
  }
    
  std::stringstream in_stream;

  for(int i = 0; i < weights.length(); ++i)
    in_stream << weights[i] << " ";
    
  SfWeightVector* w = new SfWeightVector(in_stream.str());    
    
  std::vector<float> predictions;
    
  if (prediction_type == "linear")
    sofia_ml::SvmPredictionsOnTestSet(test_data, *w, &predictions);
  else if (prediction_type == "logistic")
    sofia_ml::LogisticPredictionsOnTestSet(test_data, *w, &predictions);
  else {
    //std::cerr << "prediction " << prediction_type << " not supported.";
    //no exit called though
    error("prediction %s not supported", prediction_type.c_str());
  }
   
  delete w;

  return(predictions);

}

//private methods

SfWeightVector * RSofiaFacade::alloc_SfWeightVector(int dimensionality, int hash_mask_bits) {

  SfWeightVector* w  = NULL;
    
  if (hash_mask_bits == 0) {
    w = new SfWeightVector(dimensionality);
  } else {
    w = new SfHashWeightVector(hash_mask_bits);
  }
  //assert(w != NULL);
  //assertions should never be called when interfacing with R.
  //we will need a better way of addressing alloc success  

  return w;

}

void RSofiaFacade::define_EtaType(sofia_ml::EtaType * eta_type, const std::string & eta) {

  if (eta=="basic")
    *eta_type = sofia_ml::BASIC_ETA;
  else if (eta=="pegasos")
    *eta_type = sofia_ml::PEGASOS_ETA;
  else if (eta=="constant")
    *eta_type = sofia_ml::CONSTANT;
  else {
    error("eta type: %s not supported", eta.c_str()); 
  }
}

void RSofiaFacade::define_LearnerType(sofia_ml::LearnerType * learner_type
   , float * c
   , float * lambda_val
   , const std::string & learner
   , const float perceptron_margin_size
   , const float passive_aggressive_c
   , const float passive_aggressive_lambda
    ) {

  if (learner=="pegasos")
    *learner_type = sofia_ml::PEGASOS;
  else if (learner=="margin-perceptron") {
    *learner_type = sofia_ml::MARGIN_PERCEPTRON;
    *c = perceptron_margin_size;
  }
  else if (learner=="passive-aggressive") {
    *learner_type = sofia_ml::PASSIVE_AGGRESSIVE;
    *c = passive_aggressive_c;
    *lambda_val = passive_aggressive_lambda;
  }
  else if (learner=="logreg-pegasos")
    *learner_type = sofia_ml::LOGREG_PEGASOS;
  else if (learner=="logreg")
    *learner_type = sofia_ml::LOGREG;
  else if (learner=="least-mean-squares")
    *learner_type = sofia_ml::LMS_REGRESSION;
  else if (learner=="sgd-svm")
    *learner_type = sofia_ml::SGD_SVM;
  else if (learner=="romma")
    *learner_type = sofia_ml::ROMMA;
  else {
    //std::cerr << "learner_type " << learner << " not supported.";
    //exit(0);
    error("learner_type %s not supported", learner.c_str()); 
  }
}

void RSofiaFacade::run_outer_loop(SfWeightVector * w
   , const std::string & loop
   , const SfDataSet & training_data
   , const sofia_ml::LearnerType & learner_type
   , const sofia_ml::EtaType & eta_type
   , const float lambda_val
   , const float c
   , const int iterations
   , const float rank_step_probability)
{

  if (loop=="stochastic")
    sofia_ml::StochasticOuterLoop(
        training_data, learner_type, eta_type, lambda_val, c, iterations, w
    );
  else if (loop=="balanced-stochastic")
    sofia_ml::BalancedStochasticOuterLoop(
        training_data, learner_type, eta_type, lambda_val, c, iterations, w
    );
  else if (loop=="roc")
    sofia_ml::StochasticRocLoop(
        training_data, learner_type, eta_type, lambda_val, c, iterations, w
    );			     
  else if (loop=="rank")
    sofia_ml::StochasticRankLoop(
        training_data, learner_type, eta_type, lambda_val, c, iterations, w
    );
  else if (loop=="combined-ranking")
    sofia_ml::StochasticClassificationAndRankLoop(
        training_data, learner_type, eta_type, lambda_val, c, rank_step_probability, iterations, w
    );
  else if (loop=="combined-roc")
    sofia_ml::StochasticClassificationAndRocLoop(
        training_data, learner_type, eta_type, lambda_val, c, rank_step_probability, iterations, w
    );
  else if (loop=="query-norm-rank")
    sofia_ml::StochasticQueryNormRankLoop(
        training_data, learner_type, eta_type, lambda_val, c, iterations, w
    );
  else {
    //std::cerr << "loop_type " << loop << " not supported.";
    //exit(0);
    error("loop_type %s not supported.\n", loop.c_str());    
  }
}


RCPP_MODULE(sofia) {
   using namespace Rcpp ;

   class_<RSofiaFacade>( "RSofiaFacade" )
  
  .constructor()    
  
  .method("train_filename", &RSofiaFacade::train_filename) 
  .method("train_fit",  &RSofiaFacade::train_fit)
  .method("predict", &RSofiaFacade::predict)
   ;

}
