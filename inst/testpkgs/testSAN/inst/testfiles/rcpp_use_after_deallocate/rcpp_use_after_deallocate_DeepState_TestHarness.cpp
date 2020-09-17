#include <fstream>
#include <RInside.h>
#include <iostream>
#include <RcppDeepState.h>
#include <qs.h>
#include <DeepState.hpp>

int rcpp_use_after_deallocate(int array_size);

TEST(testSAN_deepstate_test,rcpp_use_after_deallocate_test){
  RInside R;
  std::cout << "input starts" << std::endl;
  std::ofstream array_size_stream;
  int array_size  = RcppDeepState_int();
  array_size_stream.open("/home/akhila/R/RcppDeepState/inst/testpkgs/testSAN/inst/testfiles/rcpp_use_after_deallocate/inputs/array_size");
  array_size_stream << array_size;
  std::cout << "array_size values: "<< array_size << std::endl;
  array_size_stream.close();
  std::cout << "input ends" << std::endl;
  try{
    rcpp_use_after_deallocate(array_size);
  }
  catch(Rcpp::exception& e){
    std::cout<<"Exception Handled"<<std::endl;
  }
}
