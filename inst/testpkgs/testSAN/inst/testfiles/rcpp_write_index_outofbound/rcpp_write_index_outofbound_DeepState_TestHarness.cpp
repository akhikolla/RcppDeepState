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
  std::ofstream wbound_stream;
  int wbound  = RcppDeepState_int();
  wbound_stream.open("/home/akhila/R/RcppDeepState/inst/testpkgs/testSAN/inst/testfiles/rcpp_write_index_outofbound/inputs/wbound");
  wbound_stream << wbound;
  std::cout << "wbound values: "<< wbound << std::endl;
  wbound_stream.close();
  std::cout << "input ends" << std::endl;
  try{
    rcpp_write_index_outofbound(wbound);
  }
  catch(Rcpp::exception& e){
    std::cout<<"Exception Handled"<<std::endl;
  }
}
