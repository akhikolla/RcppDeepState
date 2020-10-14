#include <Rcpp.h>
using namespace std;

// [[Rcpp::export]]
int rcpp_read_out_of_bound(int rbound){
  int *stack_array = new int[100];
  return stack_array[rbound];
  	
} 
  
