R_HOME=/home/akhila/lib/R
COMMON_FLAGS= zero_sized_array_DeepState_TestHarness.o  -I/home/akhila/R/RcppDeepState/inst/include/ -L/usr/lib/R/site-library/RInside/include/lib -Wl,-rpath=/usr/lib/R/site-library/RInside/include/lib -L${R_HOME}/lib -Wl,-rpath=${R_HOME}/lib -L/home/akhila/R/RcppDeepState/inst/include/deepstate -Wl,-rpath=/home/akhila/R/RcppDeepState/inst/include/deepstate -lR -lRInside -ldeepstate
zero_sized_array_DeepState_TestHarness : zero_sized_array_DeepState_TestHarness.o
	 clang++ -Wall -g -pedantic -o zero_sized_array_DeepState_TestHarness ${COMMON_FLAGS} ~/R/testUBSAN/src/*.o
	
zero_sized_array_DeepState_TestHarness.o : ~/R/RcppDeepState/inst/RcppDeepStatefiles/testUBSAN/zero_sized_array_DeepState_TestHarness.cpp
	 clang++ -Wall -g -pedantic -I${R_HOME}/include -I/home/akhila/R/RcppDeepState/inst/include/deepstate -I/usr/lib/R/site-library/Rcpp/include -I/usr/lib/R/site-library/RInside/include -I/home/akhila/R/RcppDeepState/inst/include/ ~/R/RcppDeepState/inst/RcppDeepStatefiles/testUBSAN/zero_sized_array_DeepState_TestHarness.cpp -o zero_sized_array_DeepState_TestHarness.o -c


