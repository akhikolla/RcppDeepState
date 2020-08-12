#include <Rcpp.h>
using namespace std;
// [[Rcpp::export]]
int use_after_free(int val){
  int *x =  (int *)malloc(sizeof(int)*val);    
  free(x);
  return x[10];
} 
  
