#include "Rcpp.h"
#include "RSofiaFacade.h"
#include "sf-sparse-vector.h"

RSofiaFacade::RSofiaFacade() {};

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
    , const bool no_bias_term) 
{
    
    // Set random seed
    srand(random_seed);
  
    // Import data into a SfDataSet structure
    SfDataSet training_data = SfDataSet(!no_bias_term);
  
    // XXX: rows start at 1, right?
    for(int i=1; i<=x.nrow(); i++) {

        // SfDataset::AddVector supports only data in string format
        std::stringstream out_stream;
        out_stream << y[i];
        
        for(int j=1; j<=x.ncol(); j++) {
            out_stream << " " << j << ":" << x[i,j];
        }
        
        training_data.AddVector(out_stream.str());
        
    }
    
    // Allocate vector of weights
    SfWeightVector* w  = NULL;
    if (hash_mask_bits == 0) {
        w = new SfWeightVector(dimensionality);
    } else {
        w = new SfHashWeightVector(hash_mask_bits);
    }
    
  
  clock_t train_start = clock();
  assert(w != NULL);

  // Default values
  float c = 0.0;
  float lambda_val = lambda;

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

  PrintElapsedTime(train_start, "Time to complete training: ");
  
  // XXX: need to destroy training_data?
  
  // Return weights
  size_t n = w->GetDimensions();
  std::vector<float> weights(n);

  for(size_t i = 0; i < n; ++i)
    weights[i] = w->ValueOf(i);
  
  return(weights);
}



RCPP_MODULE(sofia) {
   using namespace Rcpp ;
	                  
   class_<RSofiaFacade>( "RSofiaFacade" )
   // expose the default constructor
   .constructor()    
   .method("train", &RSofiaFacade::train)
   ;
}
