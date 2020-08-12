#include <Rcpp.h>
using namespace std;
// [[Rcpp::export]]
int write_index_outofbound(int val){
  int x = val; //val in range 100-1000
  int *stack_array = new int[100];
  stack_array[x+100] = 50;
  return 0; 

} 
