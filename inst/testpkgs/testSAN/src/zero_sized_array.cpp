#include <Rcpp.h>
using namespace std;
// [[Rcpp::export]]
int zero_sized_array(int val){
  int size = 0;
  int* ptr = new int[size]; 
   ptr[0] = val;
   return ptr[0];
   
} 
  
