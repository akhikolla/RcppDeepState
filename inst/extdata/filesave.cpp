#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
void callFunction(Rcpp::NumericMatrix mat) {
  Environment base("package:base");
  //Function save = base["save"];
  Function saveRDS = base["saveRDS"];
  //NumericMatrix xx(wrap(M));
  saveRDS(mat,Named("file","mat.RDs"));
  //Function unserialize = base["unserialize"];
  Function readRDS = base["readRDS"];
  //Rcpp::NumericMatrix m = mat;
  //save(m,"mats.RData");
  //unserialize(serialize(path,NULL));
  readRDS(mat);
  }

