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
  IntegerVector array_size(1)
  array_size[0]  = RcppDeepState_int();
  qs::c_qsave(array_size,"/home/akhila/R/RcppDeepState/inst/testpkgs/testSAN/inst/testfiles/rcpp_use_after_deallocate/inputs/array_size.qs",
		"high", "zstd", 1, 15, true, 1);
  std::cout << "array_size values: "<< array_size << std::endl;
  std::cout << "input ends" << std::endl;
  try{
    rcpp_use_after_deallocate(array_size[0]);
  }
  catch(Rcpp::exception& e){
    std::cout<<"Exception Handled"<<std::endl;
  }
}
