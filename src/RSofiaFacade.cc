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


#include "Rcpp.h"
#include "RSofiaFacade.h"
#include "sf-sparse-vector.h"

// this is not necessary
//RSofiaFacade::RSofiaFacade() {};

std::vector<float> RSofiaFacade::train(
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
) 
{
    
    // Set random seed
    srand(random_seed);
  
    // Import data into a SfDataSet structure
    SfDataSet training_data = SfDataSet(!no_bias_term);
 
    // i wouldn't it be better to call the constructor once?
    // maybe i'm wrong? 
    std::stringstream out_stream;
    
    // XXX: rows start at 1, right?
    // mike - no, I don't believe so
    for(int i = 0; i < x.nrow(); ++i) {

        // SfDataset::AddVector supports only data in string format
        out_stream << y[i];
        
        for(int j = 0; j < x.ncol(); ++j) {
            out_stream << " " << j << ":" << x[i,j];
        }
        
        training_data.AddVector(out_stream.str());
        out_stream.str("");        
    }
    
    // Allocate vector of weights
    SfWeightVector* w  = NULL;
    
    if (hash_mask_bits == 0) {
        w = new SfWeightVector(dimensionality);
    } else {
        w = new SfHashWeightVector(hash_mask_bits);
    }
    
    assert(w != NULL);
  
 //     clock_t train_start = clock();

  // Default values for c and lambda
  
    float c = 0.0;
    float lambda_val = lambda;
  
  // Define eta
    sofia_ml::EtaType eta_type;
  
    if (eta=="basic")
      eta_type = sofia_ml::BASIC_ETA;
    else if (eta=="pegasos")
      eta_type = sofia_ml::PEGASOS_ETA;
    else if (eta=="constant")
      eta_type = sofia_ml::CONSTANT;
    else {
      std::cerr << "eta_type " << eta << " not supported.";
      exit(0);
    }
 
  // Define learner type
    sofia_ml::LearnerType learner_type;
  
    if (learner=="pegasos")
      learner_type = sofia_ml::PEGASOS;
    else if (learner=="margin-perceptron") {
      learner_type = sofia_ml::MARGIN_PERCEPTRON;
      c = perceptron_margin_size;
    }
    else if (learner=="passive-aggressive") {
      learner_type = sofia_ml::PASSIVE_AGGRESSIVE;
      c = passive_aggressive_c;
      lambda_val = passive_aggressive_lambda;
    }
    else if (learner=="logreg-pegasos")
      learner_type = sofia_ml::LOGREG_PEGASOS;
    else if (learner=="logreg")
      learner_type = sofia_ml::LOGREG;
    else if (learner=="least-mean-squares")
      learner_type = sofia_ml::LMS_REGRESSION;
    else if (learner=="sgd-svm")
      learner_type = sofia_ml::SGD_SVM;
    else if (learner=="romma")
      learner_type = sofia_ml::ROMMA;
    else {
      std::cerr << "learner_type " << learner << " not supported.";
      exit(0);
    }
  
  // Run required outer loop
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
      std::cerr << "loop_type " << loop << " not supported.";
      exit(0);
    }

  // Clean up
  //PrintElapsedTime(train_start, "Time to complete training: ");
  // XXX: need to destroy training_data?
  
  // Return model fit
  
    size_t n = w->GetDimensions();
    std::vector<float> weights(n);

    for(size_t i = 0; i < n; ++i)
      weights[i] = w->ValueOf(i);
  
    return(weights);
}

 
std::vector<float> RSofiaFacade::predict(
  const Rcpp::NumericVector& weights, 
  const Rcpp::NumericMatrix& newdata, 
  const bool no_bias_term, 
  const std::string & prediction_type) 

{
    
    // Import data into a SfDataSet structure
   SfDataSet test_data = SfDataSet(!no_bias_term);
  
   for(int i=1; i<=newdata.nrow(); i++) {

      // SfDataset::AddVector supports only data in string format
     std::stringstream out_stream;
  
     // were you just experimenting?     

     out_stream << 0;
        
     for(int j = 1; j <= newdata.ncol(); j++) {
       out_stream << " " << j << ":" << newdata[i,j];
     }
        
     test_data.AddVector(out_stream.str());
        
   }
    
   std::stringstream in_stream;
   
   in_stream << weights[1];
    
   for(int i=2; i<=weights.length(); i++) {
     in_stream << " " << weights[i];
   }
    
   SfWeightVector* w = new SfWeightVector(in_stream.str());    
    
   std::vector<float> predictions;
    
   //clock_t predict_start = clock();
    if (prediction_type == "linear")
      sofia_ml::SvmPredictionsOnTestSet(test_data, *w, &predictions);
    else if (prediction_type == "logistic")
      sofia_ml::LogisticPredictionsOnTestSet(test_data, *w, &predictions);
    else {
      std::cerr << "prediction " << prediction_type << " not supported.";
      exit(0);
    }
   //PrintElapsedTime(predict_start, "Time to make test prediction results: ");
   
  return(predictions);
}

RCPP_MODULE(sofia) {
   using namespace Rcpp ;
	                  
   class_<RSofiaFacade>( "RSofiaFacade" )
   // expose the default constructor
   .constructor()    
   .method("train", &RSofiaFacade::train)
   .method("predict", &RSofiaFacade::predict)
   ;
}
