#ifndef R_SOFIA_FACADE_H
#define R_SOFIA_FACADE_H

#include <Rcpp.h>
#include "sf-data-set.h"
#include "sofia_cmd.h"

class r_sofia_facade {

  SfDataSet data;
  SfWeightVector * w;
  //private methods from int main() in sofia-ml.cc

  void set_seed();
  void set_empty_model();

  public:
    r_sofia_facade(std::vector<std::string>, bool);
    
    void RCommandLine(std::vector<std::string>); 
    void RTrainModel();
    
    std::vector<float> RPredictData(std::vector<std::string>, bool);
    std::vector<float> RGetWeights();
    //extractors

};

#endif
