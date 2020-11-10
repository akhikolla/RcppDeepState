#include <fstream>
#include <RInside.h>
#include <iostream>
#include <RcppDeepState.h>
#include <qs.h>
#include <DeepState.hpp>

int rcpp_read_out_of_bound(int rbound);

TEST(testSAN_deepstate_test,rcpp_read_out_of_bound_test){
  RInside R;
  std::cout << "input starts" << std::endl;
  IntegerVector rbound(1)
  rbound[0]  = RcppDeepState_int();
  qs::c_qsave(rbound,"/home/akhila/R/RcppDeepState/inst/testpkgs/testSAN/inst/testfiles/rcpp_read_out_of_bound/inputs/rbound.qs",
		"high", "zstd", 1, 15, true, 1);
  std::cout << "rbound values: "<< rbound << std::endl;
  std::cout << "input ends" << std::endl;
  try{
    rcpp_read_out_of_bound(rbound[0]);
  }
  catch(Rcpp::exception& e){
    std::cout<<"Exception Handled"<<std::endl;
  }
}
