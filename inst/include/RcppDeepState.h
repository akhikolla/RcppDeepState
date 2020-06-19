#ifndef RCPPDEEPSTATE_RCPPDEEPSTATE_H
#define RCPPDEEPSTATE_RCPPDEEPSTATE_H
#include <deepstate/DeepState.hpp>
#include <vector>
#include <iostream>
#include <Rcpp.h>
#include <fstream>

using namespace Rcpp;
using namespace deepstate;
int rand_size;
Rcpp::NumericVector Exceptional_values(){
Rcpp::NumericVector values = Rcpp::NumericVector::create(NA_REAL,R_NaN,R_PosInf,R_NegInf);
 return values;
}

int RcppDeepState_int(){
  //int val = DeepState_IntInRange(1,10);
int val = DeepState_Int();
    //LOG(INFO)<< "integer val is: "  << val <<"\n";
 return val;
}

double RcppDeepState_double(){
 int val = DeepState_Double();
//LOG(INFO) << "double value is :" << val << "\n";
return val;
}

Rcpp::NumericVector RcppDeepState_NumericVector(){
      rand_size = DeepState_IntInRange(0,100);
      //LOG(INFO)<< "size of numeric vector "  << rand_size <<"\n";
      Rcpp::NumericVector rand_numvec(rand_size);
      for(int i = 0 ; i < rand_size - 1 ;i++){      
        rand_numvec[i] = DeepState_Double();  
        }
       /*for(int i=0; i < rand_size; i++){
        LOG(TRACE) << " index: " <<  i  << " rand_Numeric vector: " << rand_numvec[i] << "\n";
       }*/
         return rand_numvec;
    }
Rcpp::IntegerVector RcppDeepState_IntegerVector(){
      int size = DeepState_IntInRange(0,100);
       //LOG(INFO)<< "size of integer vector "  << size <<"\n";
      Rcpp::IntegerVector rand_intvec(size);
      for(int i = 0 ; i < size ;i++){
      rand_intvec[i] = DeepState_Int();
      }
      /*for(int i=0; i < size; i++){
      LOG(TRACE) << " index: " <<  i  << " rand_Integer vector: " << rand_intvec[i] << "\n";
      }*/
   
   return rand_intvec;
  }

#endif
