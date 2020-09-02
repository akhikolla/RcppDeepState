#include <Rcpp.h>
using namespace std;

// [[Rcpp::export]]
int rcpp_use_after_deallocate(int array_size){
  char *x = new char[array_size];
  delete[] x;
  return x[5];
} 
  
