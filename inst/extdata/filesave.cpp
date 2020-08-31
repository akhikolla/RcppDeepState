#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
void callFunction(Rcpp::NumericVector mat) {
 Environment env = Environment::global_env();
 Function foo = env["hapy"];
 foo(mat);
 Rcout <<"mat values: "<< mat;
  }

/*** R
hapy <- function(x){
  print("In happy")
  saveRDS(x,"filex.RDs")
}
*/