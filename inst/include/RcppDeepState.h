#ifndef RCPPDEEPSTATE_RCPPDEEPSTATE_H
#define RCPPDEEPSTATE_RCPPDEEPSTATE_H
#include "DeepState.hpp"
#include <vector>
#include <iostream>
#include <Rcpp.h>
#include <fstream>
#include <armadillo>

using namespace Rcpp;
using namespace arma;
using namespace deepstate;
int rand_size;

int RcppDeepState_int(){

  int rand_value = DeepState_Int();
  return rand_value;
}

double RcppDeepState_double(){
  double rand_value = DeepState_Double();
  return rand_value;
}

Rcpp::NumericVector Missing_Ns() {
  Rcpp::NumericVector v(4);
  v[0] = R_NegInf; // -Inf
  v[1] = NA_REAL; // NA
  v[2] = R_PosInf; // Inf
  v[3] = R_NaN;
  return v;
}

Rcpp::IntegerVector Missing_Is() {
  Rcpp::IntegerVector v(1);
  v[0] = NA_INTEGER; // NA
  return v;
}



Rcpp::NumericVector RcppDeepState_NumericVector(){
  rand_size = DeepState_IntInRange(0,100);
  double missing_values[] = {DeepState_Double(),R_NaN,R_PosInf,R_NegInf,NA_REAL};
  Rcpp::NumericVector rand_numvec(rand_size);
  for(int i = 0 ; i < rand_size - 1 ;i++){      
    rand_numvec[i] = DeepState_Double();  
  }
  for(int i = 0 ; i < 5 ; i++){
    rand_numvec[DeepState_IntInRange(0,rand_size-1)] =OneOf(missing_values);
  }
  return rand_numvec;
}

Rcpp::IntegerVector RcppDeepState_IntegerVector(){
  int rand_size = DeepState_IntInRange(0,100);
  int missing_values[] = {DeepState_Int(),NA_INTEGER};
  Rcpp::IntegerVector rand_intvec(rand_size);
  for(int i = 0 ; i < rand_size ;i++){
        rand_intvec[i] = DeepState_Int();
  }
  for(int i = 0 ; i < 2 ; i++){
    rand_intvec[DeepState_IntInRange(0,rand_size-1)] = OneOf(missing_values);
  }
  return rand_intvec;
}

Rcpp::CharacterVector RcppDeepState_CharacterVector(){
  int size = DeepState_IntInRange(0,100);
  int str_len = 20;
  Rcpp::CharacterVector rand_charactervec(size);
  for(int i = 0 ; i < size ; i++){
    OneOf(
      [&] {
        rand_charactervec[i] = DeepState_CStr_C(str_len, "abcdefghijklmnopqrstuvwxyz");
      },
      [&] {
        rand_charactervec[i] = DeepState_CStrUpToLen(str_len, "abcdefghijklmnopqrstuvwxyz");
      },
      [&] {
        rand_charactervec[i] = NA_STRING;
      });
  }
  return rand_charactervec;
}

std::string RcppDeepState_string(){
  std::string rand_string;
  rand_string = DeepState_CStrUpToLen(26,"abcdefghijklmnopqrstuvwxyz");
  return rand_string;
}

Rcpp::NumericMatrix RcppDeepState_NumericMatrix(){
  int rows = DeepState_IntInRange(1,10);
  int columns = DeepState_IntInRange(1,10);
  Rcpp::NumericMatrix rand_numericmatrix(rows,columns);
  for(int i = 0 ; i < rows*columns ; i++){
    rand_numericmatrix[i] = DeepState_DoubleInRange(0,1.7E308);
  }
  return rand_numericmatrix;
}

arma::mat RcppDeepState_mat(){
  int rows = DeepState_IntInRange(1,10);
  int columns = DeepState_IntInRange(1,10);
  arma::mat rand_mat(rows,columns);
  for(int i = 0 ; i < rows ; i++){
    for(int j = 0 ; j < columns ; j++)
    rand_mat(i,j) = DeepState_Double();
  }
  return rand_mat;
}

#endif

