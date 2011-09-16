#include<iostream>
#include<iterator>
#include<functional>
#include<sstream>

#include<boost/numeric/ublas/matrix.hpp>
#include<boost/numeric/ublas/vector.hpp>
#include<boost/random/bernoulli_distribution.hpp>
#include<boost/random/normal_distribution.hpp>
#include<boost/random/mersenne_twister.hpp>

#include<boost/bind.hpp>

using namespace boost::numeric::ublas;

struct F {
  typedef int result_type;
  result_type operator()(int x) { return 2 * x; }
};

int main() {

  boost::random::mt19937 gen;
  boost::random::bernoulli_distribution<> bern(.5);
  boost::random::normal_distribution<> norm(0.,1.);

  vector<int>    x(10);
  matrix<double> y(10,10);

  std::generate(x.begin(), x.end(), boost::bind(bern, gen)); 

  for(unsigned i = 0; i < y.size1(); ++i)
    for(unsigned j = 0; j < y.size2(); ++j)
      y(i, j) = (bern(gen) ? 0. : norm(gen)); 

  std::stringstream ss;

  for(size_t i = 0; i < y.size1(); ++i) {
    ss << x(i) << " ";
    for(size_t j = 0; j < y.size2(); ++j) {
      if(y(i,j) != 0) {
        ss << (j + 1) << ":" << y(i,j) << " ";
      }
    } 
    ss << '\n';
  }

  std::cout << ss.str() << std::endl;

  return EXIT_SUCCESS;

}
