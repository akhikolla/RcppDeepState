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
  IntegerVector value(1)
  value[0]  = RcppDeepState_int();
  qs::c_qsave(value,"/home/akhila/R/RcppDeepState/inst/testpkgs/testSAN/inst/testfiles/rcpp_zero_sized_array/inputs/value.qs",
		"high", "zstd", 1, 15, true, 1);
  std::cout << "value values: "<< value << std::endl;
  std::cout << "input ends" << std::endl;
  try{
    rcpp_zero_sized_array(value[0]);
  }
  catch(Rcpp::exception& e){
    std::cout<<"Exception Handled"<<std::endl;
  }
}
