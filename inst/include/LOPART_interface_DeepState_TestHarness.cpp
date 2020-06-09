#include <deepstate/DeepState.hpp>
#include <RInside.h>
#include <iostream>
#include <RcppDeepState.h>
#include <fstream>
using namespace deepstate;
 Rcpp::DataFrame LOPART_interface(Rcpp::NumericVector input_data, Rcpp::IntegerVector input_label_start, Rcpp::IntegerVector input_label_end, Rcpp::IntegerVector input_label_changes, double penalty);
TEST(LOPART_interface_random_datatypes,LOPART_interface_test){
std::ofstream input_data_stream,loparttest;
std::ofstream input_label_start_stream;
std::ofstream input_label_end_stream;
std::ofstream input_label_changes_stream;
std::ofstream penalty_stream;
 RInside();
 Rcpp::NumericVector input_data =RcppDeepState_NumericVector();
  input_data_stream.open("input_data");
 input_data_stream<< input_data;
std::cout << "input_data values: " << input_data << "\n";
input_data_stream.close();

 Rcpp::IntegerVector input_label_start =RcppDeepState_IntegerVector();
  input_label_start_stream.open("input_label_start");
 input_label_start_stream<< input_label_start;
std::cout << "input_label_start values: " << input_label_start << "\n";
 input_label_start_stream.close();

 Rcpp::IntegerVector input_label_end =RcppDeepState_IntegerVector();
  input_label_end_stream.open("input_label_end");
 input_label_end_stream<< input_label_end;
 std::cout << "input_label_end values: " << input_label_end << "\n";
 input_label_end_stream.close();

 Rcpp::IntegerVector input_label_changes =RcppDeepState_IntegerVector();
  input_label_changes_stream.open("input_label_changes");
 input_label_changes_stream<< input_label_changes;
std::cout<< "input_label_changes values: " << input_label_changes << "\n";
 input_label_changes_stream.close();

 double penalty =RcppDeepState_double();
  penalty_stream.open("penalty");
 penalty_stream<< penalty;
 std::cout << "penalty values: " << penalty << "\n";
 penalty_stream.close();
//LOPART_interface(input_data, input_label_start, input_label_end, input_label_changes, penalty);
 
try{
 LOPART_interface(input_data, input_label_start, input_label_end, input_label_changes, penalty);
}
catch(Rcpp::exception& e){
std::cout<<"Exception Handled"<<std::endl;
} 
 }
