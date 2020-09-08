#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
Rcpp::NumericVector Missing_N() {
  Rcpp::NumericVector v(4);
  v[0] = R_NegInf; // -Inf
  v[1] = NA_REAL; // NA
  v[2] = R_PosInf; // Inf
  v[3] = R_NaN;
  return v;
}