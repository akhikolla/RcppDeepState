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
  IntegerVector u_value(1)
  u_value[0]  = RcppDeepState_int();
  qs::c_qsave(u_value,"/home/akhila/R/RcppDeepState/inst/testpkgs/testSAN/inst/testfiles/rcpp_use_uninitialized/inputs/u_value.qs",
		"high", "zstd", 1, 15, true, 1);
  std::cout << "u_value values: "<< u_value << std::endl;
  std::cout << "input ends" << std::endl;
  try{
    rcpp_use_uninitialized(u_value[0]);
  }
  catch(Rcpp::exception& e){
    std::cout<<"Exception Handled"<<std::endl;
  }
}
