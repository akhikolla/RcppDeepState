#include <fstream>
#include <RInside.h>
#include <iostream>
#include <RcppDeepState.h>
#include <qs.h>
#include <DeepState.hpp>

int rcpp_write_index_outofbound(int wbound);

TEST(testSAN_deepstate_test,rcpp_write_index_outofbound_test){
  RInside R;
  std::cout << "input starts" << std::endl;
  IntegerVector wbound(1)
  wbound[0]  = RcppDeepState_int();
  qs::c_qsave(wbound,"/home/akhila/R/RcppDeepState/inst/testpkgs/testSAN/inst/testfiles/rcpp_write_index_outofbound/inputs/wbound.qs",
		"high", "zstd", 1, 15, true, 1);
  std::cout << "wbound values: "<< wbound << std::endl;
  std::cout << "input ends" << std::endl;
  try{
    rcpp_write_index_outofbound(wbound[0]);
  }
  catch(Rcpp::exception& e){
    std::cout<<"Exception Handled"<<std::endl;
  }
}
