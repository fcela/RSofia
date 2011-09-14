#ifndef SVMLIGHT_READER_H
#define SVMLIGHT_READER_H

#include<string>
#include<fstream>
#include<iostream>
#include<cstdlib>
#include<vector>
#include<iterator>
#include<list>

#include<Rcpp.h>
 
RcppExport SEXP svmlight_reader(SEXP rfile_name);

#endif
