#include "svmlight_reader.h"

SEXP svmlight_reader(SEXP rfile_name 
  , SEXP rdim)
{

  //vector containing rows of svmlight txt file  
  std::list<std::string> svmdata;

  std::string file_name = Rcpp::as<std::string>(rfile_name); 
  int dim               = Rcpp::as<int>(rdim);
 
  //open svm datafile for reading
  std::ifstream in(file_name.c_str());

  //break if file doesn't exist
  if ( !in ) {
    return Rcpp::wrap(std::string("file does not exist"));
  }
  
  //placeholder
  std::string tmp;
  
  //we will want to remove whitespace
  std::string whitespaces(" \t\f\v\n\r");
  size_t found;

  //trailing white spaces can get you in trouble

  while(getline(in, tmp, '\n')) {
    
     found = tmp.find_last_not_of(whitespaces);
   
     if(found != std::string::npos) {
      
       tmp.erase(found + 1);
       svmdata.push_back(tmp);
    
    }
  }

  Rcpp::NumericMatrix * mat = new Rcpp::NumericMatrix(svmdata.size(), dim);
  Rcpp::IntegerVector * lab = new Rcpp::IntegerVector(svmdata.size());

  // first - first idx in string, last - last idx in string, p - midpoint in "xxx:yyy" token 
  int first, last, p;

  char * offset = NULL;
  
  float val; // place holder for values inserted into IntVector and NumMatrix
  long col_idx;
  long row_idx = 0; 
  
  for(std::list<std::string>::iterator i = svmdata.begin(); 
      i != svmdata.end();
      ++i) 
  {
    
    first = 0;
    
    last = i->find(" ");
    tmp  = i->substr(first, last-first);

    (*lab)(row_idx) = strtol(tmp.c_str(), &offset, 0);

    while(last > 0) {

      first   = ++last;
      last    = i->find(" ", last);

      tmp     = i->substr(first, last-first);
      p       = tmp.find(":");

      col_idx = strtol(tmp.substr(0, p).c_str(), &offset, 0);
      val     = strtod(tmp.substr(p+1, tmp.length()).c_str(), &offset);      
 
      (*mat)(row_idx, col_idx-1) = val;
    }
    ++row_idx;
  }

  return Rcpp::List::create (
    Rcpp::Named("labels") = *lab,
    Rcpp::Named("data")   = *mat
  );

}
