#include <deepstate/DeepState.hpp>
#include <RInside.h>
#include <iostream>
#include <RcppDeepState.h>
#include <fstream>
 int rcpp_use_after_deallocate(int size);
TEST(use_after_deallocate_random_datatypes,rcpp_use_after_deallocate_test){
std::ofstream size_stream;
 RInside();
 int size =RcppDeepState_int();
 size_stream.open("size");
size_stream<<size;
std::cout <<"size values: "<<size<< std::endl;
size_stream.close();
 try{
 rcpp_use_after_deallocate(size);
}
catch(Rcpp::exception& e){
std::cout<<"Exception Handled"<<std::endl;
} 
 }
