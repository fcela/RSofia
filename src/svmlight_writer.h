#ifndef SVMLIGHT_WRITER_H
#define SVMLIGHT_WRITER_H

#include<fstream>
#include<string>
#include<Rcpp.h>

RcppExport SEXP csv_writer(SEXP rfile_name, SEXP rdata, SEXP rlabels); 

#endif
