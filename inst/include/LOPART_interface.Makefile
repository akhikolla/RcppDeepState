R_HOME=/home/akhila/lib/R
COMMON_FLAGS= LOPART_interface_DeepState_TestHarness.o  -I/home/akhila/R/RcppDeepState/inst/include/ -L/usr/lib/R/site-library/RInside/include/lib -Wl,-rpath=/usr/lib/R/site-library/RInside/include/lib -L${R_HOME}/lib -Wl,-rpath=${R_HOME}/lib -L/home/akhila/deepstate/src/lib -Wl,-rpath=/home/akhila/deepstate/src/lib -lR -lRInside -ldeepstate
LOPART_interface_DeepState_TestHarness : LOPART_interface_DeepState_TestHarness.o
	 clang++ -o LOPART_interface_DeepState_TestHarness ${COMMON_FLAGS} ~/R/LOPART/src/*.o
	
LOPART_interface_DeepState_TestHarness.o : LOPART_interface_DeepState_TestHarness.cpp
	 clang++ -I${R_HOME}/include -I/home/akhila/deepstate/src/include -I/usr/lib/R/site-library/Rcpp/include -I/usr/lib/R/site-library/RInside/include -I/home/akhila/R/RcppDeepState/inst/include/ LOPART_interface_DeepState_TestHarness.cpp -o LOPART_interface_DeepState_TestHarness.o -c
