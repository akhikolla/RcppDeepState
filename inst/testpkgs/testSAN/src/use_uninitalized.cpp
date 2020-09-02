#include <Rcpp.h>
using namespace std;

// [[Rcpp::export]]
int rcpp_use_uninitialized(int u_value){
    int x;
    if(x < u_value)
    return u_value;
    else
    return x+u_value;
} 

