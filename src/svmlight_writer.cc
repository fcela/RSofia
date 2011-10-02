#include "svmlight_writer.h"

SEXP svmlight_writer(SEXP rfile_name, SEXP rdata, SEXP rlabels, SEXP rno_bias_term, SEXP ruse_r_metadata) {

  bool use_r_metadata = Rcpp::as<bool>(ruse_r_metadata);
  int no_bias_term = Rcpp::as<int>(rno_bias_term);

  Rcpp::NumericMatrix data(rdata);
  Rcpp::NumericVector labels(rlabels);

  Rcpp::List data_dimnames = data.attr("dimnames");
  std::vector<std::string> data_colnames = Rcpp::as<std::vector<std::string> >( data_dimnames[1] );
  std::string data_responsename = Rcpp::as<std::string> ( labels.attr("name") );

  std::string file_name = Rcpp::as<std::string>(rfile_name);

  std::ofstream of(file_name.c_str());

  SEXP return_value;

  if(of.is_open()) {

    if(use_r_metadata) {    
      of << "###R_COLUMN_NAMES:";
      of << data_responsename; 
      for(size_t i = 0; i < data_colnames.size(); ++i)
        of << "," << data_colnames[i];
      of << '\n';
    
      of << "###R_NO_BIAS_TERM:";
      of << no_bias_term;
      of << '\n';
    }
 
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
