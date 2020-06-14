#include <deepstate/DeepState.hpp>
#include <RInside.h>
#include <iostream>
#include <RcppDeepState.h>
#include <fstream>
 int rcpp_write_index_outofbound(int boundvalue);
TEST(write_index_outofbound_random_datatypes,rcpp_write_index_outofbound_test){
std::ofstream boundvalue_stream;
 RInside();
 int boundvalue =RcppDeepState_int();
 boundvalue_stream.open("boundvalue");
boundvalue_stream<<boundvalue;
std::cout <<"boundvalue values: "<<boundvalue<< std::endl;
boundvalue_stream.close();
 try{
 rcpp_write_index_outofbound(boundvalue);
}
catch(Rcpp::exception& e){
std::cout<<"Exception Handled"<<std::endl;
} 
 }
