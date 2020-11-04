#include <Rcpp.h>
using namespace std;

// [[Rcpp::export]]
int rcpp_write_index_outofbound(int wbound){
  int x = wbound;
  int *stack_array = new int[100];
  stack_array[x+100] = 50;
  return 0; 

} 
