#include <deepstate/DeepState.hpp>
#include <RInside.h>
#include <iostream>
#include <RcppDeepState.h>
#include <fstream>
 int rcpp_use_after_free(int size_free);
TEST(use_after_free_random_datatypes,rcpp_use_after_free_test){
std::ofstream size_free_stream;
 RInside();
 int size_free =RcppDeepState_int();
 size_free_stream.open("size_free");
size_free_stream<<size_free;
std::cout <<"size_free values: "<<size_free<< std::endl;
size_free_stream.close();
 try{
 rcpp_use_after_free(size_free);
}
catch(Rcpp::exception& e){
std::cout<<"Exception Handled"<<std::endl;
} 
 }
