#include "r_sofia_facade.h"

r_sofia_facade::r_sofia_facade(std::vector<std::string> svm_lite_data, bool use_bias_term) 
  : data(use_bias_term), w(NULL) 
{
  for(std::vector<std::string>::iterator i = svm_lite_data.begin();
      i != svm_lite_data.end();
      ++i) 
  {
    data.AddVector(*i);  
  }
}

/*********
* private methods 
**********/

void r_sofia_facade::set_seed() {
  if ( CMD_LINE_INTS ["--random_seed"] == 0 ) {
    srand(time(NULL));
  } else {
    std::cerr << "Using random seed: " << CMD_LINE_INTS["--random_seed"] << std::endl;
    srand(CMD_LINE_INTS["--random_seed"]);
  }
}

void r_sofia_facade::set_empty_model() {
  if(CMD_LINE_INTS["--hash_mask_bits"] == 0) {
    w = new SfWeightVector(CMD_LINE_INTS["--dimensionality"]);
  } else {
    w = new SfWeightVector(CMD_LINE_INTS["--hash_mask_bits"]);
  }
}

/*******
* public methods
*******/

void r_sofia_facade::RCommandLine(std::vector<std::string> args) {

  int argc = args.size();

  char ** argv;

  argv = new char* [argc];

  for(size_t i = 0; i < argc; ++i) {
    argv[i] = new char[args[i].size() + 1];
    std::copy(args[i].begin(), args[i].end(), argv[i]);
    argv[i][args[i].size()] = '\0';
  }

  CommandLine(argc, argv);

}


void r_sofia_facade::RTrainModel() {

  set_seed();
  set_empty_model();

  TrainModel(data, w);

}


std::vector<float> r_sofia_facade::RPredictData(std::vector<std::string> pred, bool use_bias_term) {

  //*** initialize test data ***//

  SfDataSet test_data(use_bias_term);

  for(std::vector<string>::iterator i = pred.begin();
      i != pred.end();
      ++i) 
  {
    test_data.AddVector(*i);
  }

  std::vector<float> predictions;

  if (CMD_LINE_STRINGS["--prediction_type"] == "linear")
    sofia_ml::SvmPredictionsOnTestSet(test_data, *w, &predictions);
  else if (CMD_LINE_STRINGS["--prediction_type"] == "logistic")
    sofia_ml::LogisticPredictionsOnTestSet(test_data, *w, &predictions);
  else {
    std::cerr << "--prediction " << CMD_LINE_STRINGS["--prediction_type"]
        << " not supported.";
    exit(0);
  }

  return predictions;

}

std::vector<float> r_sofia_facade::RGetWeights() {

  size_t n = w->GetDimensions();
  std::vector<float> res(n);

  for(size_t i = 0; i < n; ++i)
    res[i] = w->ValueOf(i);
  
  return res;

}

RCPP_MODULE(sofia) {
	using namespace Rcpp ;
	                  
	class_<r_sofia_facade>( "r_sofia_facade" )
	
	    // expose the default constructor
	    .constructor<std::vector<std::string>, bool>()    
        .method( "RCommandLine", &r_sofia_facade::RCommandLine )	    
        .method( "RTrainModel", &r_sofia_facade::RTrainModel )	
        .method( "RGetWeights", &r_sofia_facade::RGetWeights )
        .method( "RPredictData" , &r_sofia_facade::RPredictData )

  ;
}
