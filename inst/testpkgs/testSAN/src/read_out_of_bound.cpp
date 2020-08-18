//#include <Rcpp.h>
//using namespace Rcpp;

#include <Rcpp.h>
using namespace std;
// [[Rcpp::export]]
int rcpp_read_out_of_bound(int rbound){
  int *stack_array = new int[rbound];
  return stack_array[rbound+100];
  	
} 
  
