#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
Rcpp::NumericVector callFunction(Rcpp::NumericVector mat) {
  Environment base("package:base");
  Function saveRDS = base["saveRDS"];
  saveRDS(mat,"mat.RDs");
  Function readRDS = base["readRDS"];
  Rcpp::NumericVector r= readRDS("mat.RDs");
  return r;
  }
