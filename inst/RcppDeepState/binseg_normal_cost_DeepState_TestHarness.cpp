#include <deepstate/DeepState.hpp>
#include <RInside.h>
#include <iostream>
#include <RcppDeepState.h>
#include <fstream>
 Rcpp::List rcpp_binseg_normal_cost(const Rcpp::NumericVector data_vec, const Rcpp::IntegerVector max_segments);
TEST(binseg_normal_cost_random_datatypes,rcpp_binseg_normal_cost_test){
std::ofstream data_vec_stream;
std::ofstream max_segments_stream;
 RInside();
  Rcpp::NumericVector data_vec  = RcppDeepState_NumericVector ();
 data_vec_stream.open("data_vec");
data_vec_stream<<data_vec;
data_vec_stream.close();
  Rcpp::IntegerVector max_segments  = RcppDeepState_IntegerVector ();
 max_segments_stream.open("max_segments");
max_segments_stream<<max_segments;
max_segments_stream.close();
 try{
 rcpp_binseg_normal_cost(data_vec, max_segments);
}
catch(Rcpp::exception& e){
std::cout<<"Exception Handled"<<std::endl;
} 
 }
