#include <deepstate/DeepState.hpp>
#include <RInside.h>
#include <iostream>
#include <RcppDeepState.h>
#include <fstream>
 int rcpp_zero_sized_array(int vectorvalue);
TEST(zero_sized_array_random_datatypes,rcpp_zero_sized_array_test){
std::ofstream vectorvalue_stream;
 RInside();
 int vectorvalue =RcppDeepState_int();
 vectorvalue_stream.open("vectorvalue");
vectorvalue_stream<<vectorvalue;
std::cout <<"vectorvalue values: "<<vectorvalue<< std::endl;
vectorvalue_stream.close();
 try{
 rcpp_zero_sized_array(vectorvalue);
}
catch(Rcpp::exception& e){
std::cout<<"Exception Handled"<<std::endl;
} 
 }
