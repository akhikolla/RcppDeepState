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
  IntegerVector alloc_size(1)
  alloc_size[0]  = RcppDeepState_int();
  qs::c_qsave(alloc_size,"/home/akhila/R/RcppDeepState/inst/testpkgs/testSAN/inst/testfiles/rcpp_use_after_free/inputs/alloc_size.qs",
		"high", "zstd", 1, 15, true, 1);
  std::cout << "alloc_size values: "<< alloc_size << std::endl;
  std::cout << "input ends" << std::endl;
  try{
    rcpp_use_after_free(alloc_size[0]);
  }
  catch(Rcpp::exception& e){
    std::cout<<"Exception Handled"<<std::endl;
  }
}
