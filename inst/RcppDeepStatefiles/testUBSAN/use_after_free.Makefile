R_HOME=/home/akhila/lib/R
R_INSIDE_LIB=${shell locate "/usr/*RInside/lib"}
R_INSIDE=${shell locate "/usr/*RInside/include"}
RCPP_PATH=${shell locate "/usr/*Rcpp/include"}
COMMON_FLAGS= use_after_free_DeepState_TestHarness.o -I/home/usr/R/RcppDeepState/inst/include/ -L${R_INSIDE} -Wl,-rpath=${R_INSIDE_LIB} -L${R_HOME}/lib -Wl,-rpath=${R_HOME}/lib -L/home/usr/R/RcppDeepState/inst/deepstate -Wl,-rpath=/home/usr/R/RcppDeepState/inst/deepstate -lR -lRInside -ldeepstate

use_after_free_DeepState_TestHarness : use_after_free_DeepState_TestHarness.o
	 clang++ -o use_after_free_DeepState_TestHarness ${COMMON_FLAGS} ~/R/testUBSAN/src/*.o
	
use_after_free_DeepState_TestHarness.o : ~/R/RcppDeepState/inst/RcppDeepStatefiles/testUBSAN/use_after_free_DeepState_TestHarness.cpp
	 clang++ -I${R_HOME}/include -I/home/usr/R/RcppDeepState/inst/deepstate -I${RCPP_PATH} -I${R_INSIDE} -I/home/usr/R/RcppDeepState/inst/include/ ~/R/RcppDeepState/inst/RcppDeepStatefiles/testUBSAN/use_after_free_DeepState_TestHarness.cpp -o use_after_free_DeepState_TestHarness.o -c

