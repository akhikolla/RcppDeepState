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
  std::ofstream rbound_stream;
  int rbound  = RcppDeepState_int();
  rbound_stream.open("/home/akhila/R/RcppDeepState/inst/testpkgs/testSAN/inst/testfiles/rcpp_read_out_of_bound/inputs/rbound");
  rbound_stream << rbound;
  std::cout << "rbound values: "<< rbound << std::endl;
  rbound_stream.close();
  std::cout << "input ends" << std::endl;
  try{
    rcpp_read_out_of_bound(rbound);
  }
  catch(Rcpp::exception& e){
    std::cout<<"Exception Handled"<<std::endl;
  }
}
