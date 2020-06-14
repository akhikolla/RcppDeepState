R_HOME=/home/akhila/lib/R
COMMON_FLAGS= use_after_free_DeepState_TestHarness.o  -I/home/akhila/R/RcppDeepState/inst/include/ -L/usr/lib/R/site-library/RInside/include/lib -Wl,-rpath=/usr/lib/R/site-library/RInside/include/lib -L${R_HOME}/lib -Wl,-rpath=${R_HOME}/lib -L/home/akhila/deepstate/src/lib -Wl,-rpath=/home/akhila/deepstate/src/lib -lR -lRInside -ldeepstate
use_after_free_DeepState_TestHarness : use_after_free_DeepState_TestHarness.o
	 clang++ -Wall -g -pedantic -o use_after_free_DeepState_TestHarness ${COMMON_FLAGS} ~/R/testUBSAN/src/*.o
	
use_after_free_DeepState_TestHarness.o : /home/travis/build/akhikolla/RcppDeepState/RcppDeepState.Rcheck/RcppDeepState/RcppDeepStatefiles/testUBSAN/use_after_free_DeepState_TestHarness.cpp
	 clang++ -Wall -g -pedantic -I${R_HOME}/include -I/home/akhila/deepstate/src/include -I/usr/lib/R/site-library/Rcpp/include -I/usr/lib/R/site-library/RInside/include -I/home/akhila/R/RcppDeepState/inst/include/ /home/travis/build/akhikolla/RcppDeepState/RcppDeepState.Rcheck/RcppDeepState/RcppDeepStatefiles/testUBSAN/use_after_free_DeepState_TestHarness.cpp -o use_after_free_DeepState_TestHarness.o -c


