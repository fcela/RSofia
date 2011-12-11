#include "svmlight_writer.h"

SEXP svmlight_writer(SEXP rfile_name, SEXP rdata, SEXP rlabels) {

  Rcpp::NumericMatrix data(rdata);
  Rcpp::NumericVector labels(rlabels);

  std::string file_name = Rcpp::as<std::string>(rfile_name);

  std::ofstream of(file_name.c_str());

  SEXP return_value;

  if(of.is_open()) {

    for(size_t i = 0; i < data.nrow(); ++i) {
      of << labels(i) << " ";
      for(size_t j = 0; j < data.ncol(); ++j) {
        if(data(i,j) != 0) {
          of << (j + 1) << ":" << data(i,j) << " ";
        }
      } 
      of << '\n';
    }
    
    of.close();

    return_value = Rcpp::wrap(0);

  } else {
    return_value = Rcpp::wrap(std::string("Error Opening File\n"));
  }

  return return_value;

}
