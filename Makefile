R_HOME= /home/akhila/lib/R
 COMMON_FLAGS = newtest.o -I/home/akhila/R/x86_64-pc-linux-gnu-library/3.6/RcppDeepState/include -I${HOME}/.RcppDeepState/deepstate-master/build -I${HOME}/.RcppDeepState/deepstate-master/src/include -L/home/akhila/R/x86_64-pc-linux-gnu-library/3.6/RInside/lib -Wl,-rpath=/home/akhila/R/x86_64-pc-linux-gnu-library/3.6/RInside/lib -L${R_HOME}/lib -Wl,-rpath=${R_HOME}/lib -L${HOME}/.RcppDeepState/deepstate-master/build -Wl,-rpath=${HOME}/.RcppDeepState/deepstate-master/build -lR -lRInside -ldeepstate 

newtest : newtest.o 
	 clang++ -g -o newtest ${COMMON_FLAGS} -I${R_HOME}/include -I /home/akhila/R/x86_64-pc-linux-gnu-library/3.6/Rcpp/include  -I /home/akhila/R/x86_64-pc-linux-gnu-library/3.6/RcppArmadillo/include -I/home/akhila/lib/R/library/base   -I ${HOME}/.RcppDeepState/deepstate-master/src/include /home/akhila/R/RcppDeepState/inst/extdata/filesave.cpp
	./newtest --fuzz
newtest.o : newtest.cpp
	clang++ -g -I${R_HOME}/include -I/home/akhila/R/x86_64-pc-linux-gnu-library/3.6/Rcpp/include -I/home/akhila/R/x86_64-pc-linux-gnu-library/3.6/RcppArmadillo/include -I/home/akhila/R/x86_64-pc-linux-gnu-library/3.6/RInside/include -I/home/akhila/R/x86_64-pc-linux-gnu-library/3.6/RcppDeepState/include newtest.cpp -o newtest.o -c
