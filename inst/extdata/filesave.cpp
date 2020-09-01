#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
void callFunction(Rcpp::NumericMatrix mat) {
  Environment base("package:base");
  Function saveRDS = base["saveRDS"];
  Function readRDS = base["readRDS"];
  NumericMatrix xx(wrap(mat));
  saveRDS(xx,Named("file","fun.RDs"));
  readRDS("fun.RDs");
  }

