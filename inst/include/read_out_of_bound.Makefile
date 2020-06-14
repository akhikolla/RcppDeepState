R_HOME=/home/akhila/lib/R
COMMON_FLAGS= read_out_of_bound_DeepState_TestHarness.o  -I/home/akhila/R/RcppDeepState/inst/include/ -L/usr/lib/R/site-library/RInside/include/lib -Wl,-rpath=/usr/lib/R/site-library/RInside/include/lib -L${R_HOME}/lib -Wl,-rpath=${R_HOME}/lib -L/home/akhila/deepstate/src/lib -Wl,-rpath=/home/akhila/deepstate/src/lib -lR -lRInside -ldeepstate
read_out_of_bound_DeepState_TestHarness : read_out_of_bound_DeepState_TestHarness.o
	 clang++ -Wall -g -pedantic -o read_out_of_bound_DeepState_TestHarness ${COMMON_FLAGS} ~/R/testUBSAN/src/*.o
	
read_out_of_bound_DeepState_TestHarness.o : ~/R/RcppDeepState/inst/RcppDeepStatefiles/testUBSAN/read_out_of_bound_DeepState_TestHarness.cpp
	 clang++ -Wall -g -pedantic -I${R_HOME}/include -I/home/akhila/deepstate/src/include -I/usr/lib/R/site-library/Rcpp/include -I/usr/lib/R/site-library/RInside/include -I/home/akhila/R/RcppDeepState/inst/include/ ~/R/RcppDeepState/inst/RcppDeepStatefiles/testUBSAN/read_out_of_bound_DeepState_TestHarness.cpp -o read_out_of_bound_DeepState_TestHarness.o -c
