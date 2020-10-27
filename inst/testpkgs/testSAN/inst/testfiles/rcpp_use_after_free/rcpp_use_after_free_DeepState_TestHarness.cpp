#include <fstream>
#include <RInside.h>
#include <iostream>
#include <RcppDeepState.h>
#include <qs.h>
#include <DeepState.hpp>

int rcpp_use_after_free(int alloc_size);

TEST(testSAN_deepstate_test,rcpp_use_after_free_test){
  RInside R;
  std::cout << "input starts" << std::endl;
  std::ofstream alloc_size_stream;
  int alloc_size  = RcppDeepState_int();
  alloc_size_stream.open("/home/akhila/R/RcppDeepState/inst/testpkgs/testSAN/inst/testfiles/rcpp_use_after_free/inputs/alloc_size");
  alloc_size_stream << alloc_size;
  std::cout << "alloc_size values: "<< alloc_size << std::endl;
  alloc_size_stream.close();
  std::cout << "input ends" << std::endl;
  try{
    rcpp_use_after_free(alloc_size);
  }
  catch(Rcpp::exception& e){
    std::cout<<"Exception Handled"<<std::endl;
  }
}
