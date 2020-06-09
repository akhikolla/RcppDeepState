R_HOME=/home/akhila/lib/R
COMMON_FLAGS= binseg_normal_cost_DeepState_TestHarness.o  -I/home/akhila/R/RcppDeepState/inst/include/ -L/usr/lib/R/site-library/RInside/include/lib -Wl,-rpath=/usr/lib/R/site-library/RInside/include/lib -L${R_HOME}/lib -Wl,-rpath=${R_HOME}/lib -L/home/akhila/deepstate/src/lib -Wl,-rpath=/home/akhila/deepstate/src/lib -lR -lRInside -ldeepstate
binseg_normal_cost_DeepState_TestHarness : binseg_normal_cost_DeepState_TestHarness.o
	 clang++ -o binseg_normal_cost_DeepState_TestHarness ${COMMON_FLAGS} /home/akhila/R/binsegRcpp/src/*.o
	./binseg_normal_cost_DeepState_TestHarness --fuzz
binseg_normal_cost_DeepState_TestHarness.o : binseg_normal_cost_DeepState_TestHarness.cpp
	 clang++ -I${R_HOME}/include -I/home/akhila/deepstate/src/include -I/usr/lib/R/site-library/Rcpp/include -I/usr/lib/R/site-library/RInside/include -I/home/akhila/R/RcppDeepState/inst/include/ binseg_normal_cost_DeepState_TestHarness.cpp -o binseg_normal_cost_DeepState_TestHarness.o -c
