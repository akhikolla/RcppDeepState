#include <deepstate/DeepState.hpp>
#include <RInside.h>
#include <iostream>
#include <RcppDeepState.h>
#include <fstream>
 int rcpp_read_out_of_bound(int sizeofarray);
TEST(read_out_of_bound_random_datatypes,rcpp_read_out_of_bound_test){
std::ofstream sizeofarray_stream;
 RInside();
 int sizeofarray =RcppDeepState_int();
 sizeofarray_stream.open("sizeofarray");
sizeofarray_stream<<sizeofarray;
std::cout <<"sizeofarray values: "<<sizeofarray<< std::endl;
sizeofarray_stream.close();
 try{
 rcpp_read_out_of_bound(sizeofarray);
}
catch(Rcpp::exception& e){
std::cout<<"Exception Handled"<<std::endl;
} 
 }
