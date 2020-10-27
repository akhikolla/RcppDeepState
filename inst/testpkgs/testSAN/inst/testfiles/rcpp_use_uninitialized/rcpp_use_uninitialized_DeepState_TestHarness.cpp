#include <fstream>
#include <RInside.h>
#include <iostream>
#include <RcppDeepState.h>
#include <qs.h>
#include <DeepState.hpp>

int rcpp_use_uninitialized(int u_value);

TEST(testSAN_deepstate_test,rcpp_use_uninitialized_test){
  RInside R;
  std::cout << "input starts" << std::endl;
  std::ofstream u_value_stream;
  int u_value  = RcppDeepState_int();
  u_value_stream.open("/home/akhila/R/RcppDeepState/inst/testpkgs/testSAN/inst/testfiles/rcpp_use_uninitialized/inputs/u_value");
  u_value_stream << u_value;
  std::cout << "u_value values: "<< u_value << std::endl;
  u_value_stream.close();
  std::cout << "input ends" << std::endl;
  try{
    rcpp_use_uninitialized(u_value);
  }
  catch(Rcpp::exception& e){
    std::cout<<"Exception Handled"<<std::endl;
  }
}
