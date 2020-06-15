R_HOME=/home/travis/R-bin/lib/R
R_INSIDE_LIB=${shell locate "/usr/local/*RInside/libs"}
R_INSIDE=${shell locate "/usr/local/*RInside/include"}
RCPP_PATH=${shell locate "/usr/local/*Rcpp/include"}

COMMON_FLAGS= use_after_free_DeepState_TestHarness.o -I/home/usr/R/RcppDeepState/inst/include/ -L${R_INSIDE} -Wl,-rpath=${R_INSIDE_LIB} -L${R_HOME}/lib -Wl,-rpath=${R_HOME}/lib -L/home/usr/R/RcppDeepState/inst/deepstate -Wl,-rpath=/home/usr/R/RcppDeepState/inst/deepstate -lR -lRInside -ldeepstate

use_after_free_DeepState_TestHarness : use_after_free_DeepState_TestHarness.o
	 clang++ -o use_after_free_DeepState_TestHarness ${COMMON_FLAGS} 
	
use_after_free_DeepState_TestHarness.o : /home/travis/build/akhikolla/RcppDeepState/RcppDeepState.Rcheck/RcppDeepState/RcppDeepStatefiles/testUBSAN/use_after_free_DeepState_TestHarness.cpp
	 clang++ -I${R_HOME}/include -I/home/usr/R/RcppDeepState/inst/deepstate -I${RCPP_PATH} -I${R_INSIDE} -I/home/usr/R/RcppDeepState/inst/include/ /home/travis/build/akhikolla/RcppDeepState/RcppDeepState.Rcheck/RcppDeepState/RcppDeepStatefiles/testUBSAN/use_after_free_DeepState_TestHarness.cpp -o use_after_free_DeepState_TestHarness.o -c
/home/travis/R-bin/lib/R/lib
