//#include <Rcpp.h>
//using namespace Rcpp;

#include <Rcpp.h>
using namespace std;
// [[Rcpp::export]]
int read_out_of_bound(int val){
  int *stack_array = new int[val];
  return stack_array[val+100];
  	
} 
  
