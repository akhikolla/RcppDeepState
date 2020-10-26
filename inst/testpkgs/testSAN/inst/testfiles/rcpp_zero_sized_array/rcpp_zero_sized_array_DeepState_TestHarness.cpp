#include <fstream>
#include <RInside.h>
#include <iostream>
#include <RcppDeepState.h>
#include <qs.h>
#include <DeepState.hpp>

int rcpp_zero_sized_array(int value);

TEST(testSAN_deepstate_test,rcpp_zero_sized_array_test){
  RInside R;
  std::cout << "input starts" << std::endl;
  std::ofstream value_stream;
  int value  = RcppDeepState_int();
  value_stream.open("/home/akhila/R/RcppDeepState/inst/testpkgs/testSAN/inst/testfiles/rcpp_zero_sized_array/inputs/value");
  value_stream << value;
  std::cout << "value values: "<< value << std::endl;
  value_stream.close();
  std::cout << "input ends" << std::endl;
  try{
    rcpp_zero_sized_array(value);
  }
  catch(Rcpp::exception& e){
    std::cout<<"Exception Handled"<<std::endl;
  }
}
