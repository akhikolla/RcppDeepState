#include <Rcpp.h>
using namespace std;

// [[Rcpp::export]]
int rcpp_zero_sized_array(int value){
  int size = 0;
  int* ptr = new int[size]; 
   ptr[0] = value;
   return ptr[0];
   
} 
  