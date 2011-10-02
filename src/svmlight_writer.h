#ifndef SVMLIGHT_WRITER_H
#define SVMLIGHT_WRITER_H

#include<fstream>
#include<string>
#include<iterator>
#include<Rcpp.h>

RcppExport SEXP svmlight_writer(SEXP rfile_name, SEXP rdata, SEXP rlabels, SEXP rno_bias_term, SEXP ruse_r_metadata); 

#endif
