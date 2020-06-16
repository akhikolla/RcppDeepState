R_HOME=/home/travis/R-bin/lib/R

COMMON_FLAGS= write_index_outofbound_DeepState_TestHarness.o -I/home/akhila/R/RcppDeepState/inst/include/ -L/usr/local/lib/R/site-library/RInside/lib -Wl,-rpath=/usr/local/lib/R/site-library/RInside/lib -L${R_HOME}/lib -Wl,-rpath=${R_HOME}/lib -L/home/travis/build/akhikolla/RcppDeepState/RcppDeepState.Rcheck/RcppDeepState/include/deepstate -Wl,-rpath=home/travis/build/akhikolla/RcppDeepState/RcppDeepState.Rcheck/RcppDeepState/include/deepstate -lR -lRInside -ldeepstate
write_index_outofbound_DeepState_TestHarness : write_index_outofbound_DeepState_TestHarness.o
	clang++ -o write_index_outofbound_DeepState_TestHarness ${COMMON_FLAGS} /home/travis/build/akhikolla/RcppDeepState/RcppDeepState.Rcheck/RcppDeepState/testpkgs/testSAN/src/*.o
	valgrind --tool=memcheck --leak-check=yes ./write_index_outofbound_DeepState_TestHarness --fuzz --min_log_level 0	
write_index_outofbound_DeepState_TestHarness.o : /home/travis/build/akhikolla/RcppDeepState/RcppDeepState.Rcheck/RcppDeepState/RcppDeepStatefiles/testUBSAN/write_index_outofbound_DeepState_TestHarness.cpp
	 clang++ -I${R_HOME}/include -I/home/akhila/deepstate/src/include -I/usr/local/lib/R/site-library/Rcpp/include -I/usr/local/lib/R/site-library/RInside/include -I/home/akhila/R/RcppDeepState/inst/include/ /home/travis/build/akhikolla/RcppDeepState/RcppDeepState.Rcheck/RcppDeepState/RcppDeepStatefiles/testUBSAN/write_index_outofbound_DeepState_TestHarness.cpp -o write_index_outofbound_DeepState_TestHarness.o -c
