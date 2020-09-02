#include <Rcpp.h>
using namespace std;

// [[Rcpp::export]]
int rcpp_use_after_free(int alloc_size){
  int *x =  (int *)malloc(sizeof(int)*alloc_size);    
  free(x);
  return x[10];
} 
  
