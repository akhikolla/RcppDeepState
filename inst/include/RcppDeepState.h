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

//default integer generation
int RcppDeepState_int(){
  int rand_value = DeepState_Int();
  return rand_value;
}

//inclusive range integer generation
int RcppDeepState_int(int low,int high){
  int rand_value = DeepState_IntInRange(low,high);
  return rand_value;
}

//default double generation
double RcppDeepState_double(){
  double rand_value = DeepState_Double();
  return rand_value;
}

//inclusive range double generation
double RcppDeepState_double(double low,double high){
  double rand_value = DeepState_DoubleInRange(low,high);
  return rand_value;
}

//default NumericVector generation
Rcpp::NumericVector RcppDeepState_NumericVector(){
  rand_size = DeepState_IntInRange(0,100);
  double missing_values[] = {DeepState_Double(),R_NaN,R_PosInf,R_NegInf,NA_REAL};
  Rcpp::NumericVector rand_numvec(rand_size);
   OneOf(
	    [&] {
	      for(int i = 0 ; i < rand_size;i++){      
               rand_numvec[i] = DeepState_Double();  
             }
	    },
	    [&] {
std::cout << "Missing value" << std::endl;
            for(int i = 0 ; i < rand_size - 1 ;i++){      
                 rand_numvec[i] = DeepState_Double();  
             }
            for(int i = 0 ; i < 5 ; i++){
                 rand_numvec[DeepState_IntInRange(0,rand_size-1)] = OneOf(missing_values);
              }
	    });

  return rand_numvec;
}

//inclusive range NumericVector generation
Rcpp::NumericVector RcppDeepState_NumericVector(int size,int low,int high){
  double missing_values[] = {DeepState_Double(),R_NaN,R_PosInf,R_NegInf,NA_REAL};
  Rcpp::NumericVector rand_numvec(size);
  OneOf(
	    [&] {
	      for(int i = 0 ; i < rand_size;i++){      
               rand_numvec[i] = DeepState_DoubleInRange(low,high); 
             }
	    },
	    [&] {
std::cout << "Missing value" << std::endl;
              for(int i = 0 ; i < rand_size - 1 ;i++){      
                 rand_numvec[i] = DeepState_DoubleInRange(low,high);   
             }
            for(int i = 0 ; i < 5 ; i++){
                 rand_numvec[DeepState_IntInRange(0,size-1)] = OneOf(missing_values);
              }
	    });
  return rand_numvec;
}

//default IntegerVector generation
Rcpp::IntegerVector RcppDeepState_IntegerVector(){
  int rand_size = DeepState_IntInRange(0,100);
  int missing_values[] = {DeepState_Int(),NA_INTEGER};
  Rcpp::IntegerVector rand_intvec(rand_size);
   OneOf(
	    [&] {
	      for(int i = 0 ; i < rand_size;i++){      
               rand_intvec[i] = DeepState_Int();  
             }
	    },
	    [&] {
std::cout << "Missing value" << std::endl;
            for(int i = 0 ; i < rand_size ;i++){
	        rand_intvec[i] = DeepState_Int();
	    }
           for(int i = 0 ; i < 2 ; i++){
    		rand_intvec[DeepState_IntInRange(0,rand_size-1)] = OneOf(missing_values);
  	   }
	    });

  return rand_intvec;
}

//inclusive range IntegerVector generation
Rcpp::IntegerVector RcppDeepState_IntegerVector(int size,int low,int high){
  int missing_values[] = {DeepState_Int(),NA_INTEGER};
  Rcpp::IntegerVector rand_intvec(size);
  OneOf(
	    [&] {
	      for(int i = 0 ; i < rand_size;i++){      
                rand_intvec[i] = DeepState_IntInRange(low,high);
             }
	    },
	    [&] {
              std::cout << "Missing value" << std::endl;
		for(int i = 0 ; i < rand_size ;i++){
	         rand_intvec[i] = DeepState_IntInRange(low,high);
	  	}
  		for(int i = 0 ; i < 2 ; i++){
    		rand_intvec[DeepState_IntInRange(0,size-1)] = OneOf(missing_values);
  	  	}
	    });

  return rand_intvec;
}

//default NumericMatrix generation
Rcpp::NumericMatrix RcppDeepState_NumericMatrix(){
  double missing_values[] = {DeepState_Double(),R_NaN,R_PosInf,R_NegInf,NA_REAL};
  int rows = DeepState_IntInRange(1,10);
  int columns = DeepState_IntInRange(1,10);
  Rcpp::NumericMatrix rand_numericmatrix(rows,columns);
    OneOf(
	    [&] {
	      for(int i = 0 ; i < rows*columns ; i++){
    		rand_numericmatrix[i] = DeepState_DoubleInRange(0,1.7E308);
 		 }
	    },
	    [&] {
std::cout << "Missing value" << std::endl;
           for(int i = 0 ; i < rows*columns ; i++){
    		rand_numericmatrix[i] = DeepState_DoubleInRange(0,1.7E308);
  		}
           for(int i = 0 ; i < 5 ; i++){
    		rand_numericmatrix[DeepState_IntInRange(0,rows*columns-1)] = OneOf(missing_values);
  	     }
	    });

  return rand_numericmatrix;
}

//inclusive range NumericMatrix generation
Rcpp::NumericMatrix RcppDeepState_NumericMatrix(int row,int column,int low,int high){
   double missing_values[] = {DeepState_Double(),R_NaN,R_PosInf,R_NegInf,NA_REAL};
   int rows = row;
   int columns = column;
  Rcpp::NumericMatrix rand_numericmatrix(rows,columns);
  OneOf(
	    [&] {
	      for(int i = 0 ; i < rows*columns ; i++){
    		rand_numericmatrix[i] = DeepState_DoubleInRange(low,high);
  		}
	    },
	    [&] {
std::cout << "Missing value" << std::endl;
            	for(int i = 0 ; i < rows*columns ; i++){
    			rand_numericmatrix[i] = DeepState_DoubleInRange(low,high);
  		}
    		for(int i = 0 ; i < 5 ; i++){
    			rand_numericmatrix[DeepState_IntInRange(0,rows*columns-1)] = OneOf(missing_values);
  	         }
	    });


  return rand_numericmatrix;
}

//default CharacterVector generation
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

//default string generation
std::string RcppDeepState_string(){
  std::string rand_string;
  rand_string = DeepState_CStrUpToLen(26,"abcdefghijklmnopqrstuvwxyz");
  return rand_string;
}

//default arma::mat generation
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

