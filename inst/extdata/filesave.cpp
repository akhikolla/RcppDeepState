#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
void callFunction(Rcpp::NumericMatrix mat) {
  Environment base("package:base");
  Function save = base["save"];
  //Function unserialize = base["unserialize"];
  //Function readRDS = base["readRDS"];
  Rcpp::NumericMatrix m = mat;
  //save(m,"mats.RData");
  //unserialize(serialize(path,NULL));
  //readRDS(path);
  }

