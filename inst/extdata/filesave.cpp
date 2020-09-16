// [[Rcpp::depends(qs)]]
#include <Rcpp.h>
#include <qs.h>
using namespace Rcpp;

// [[Rcpp::export]]
void test(Rcpp::NumericVector nv) {
  qs::c_qsave(nv, "~/Music/myfiles.qs", "high", "zstd", 1, 15, true, 1);
}