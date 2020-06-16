##' @title  creates makefiles for above created testharness in package
##' @param package to the RcppExports file
##' @param fun_name name of function to get makefile
##' @export
create_makefile <-function(package,fun_name){
  package_name <- package
  makefile.name <- gsub("rcpp_","",paste0(fun_name,".Makefile"))
  test_harness <- gsub("rcpp_","",paste0(fun_name,"_DeepState_TestHarness"))
  makefile.name.o <-paste0(test_harness,".o")
  makefile.name.cpp <-paste0(test_harness,".cpp")
  file.create((makefile.name), recursive=TRUE)
  path <-paste("R_HOME=",R.home())
  write(path,makefile.name,append = TRUE) 
  flags <- paste("COMMON_FLAGS=",makefile.name.o," -I/home/akhila/R/RcppDeepState/inst/include/ -L/usr/lib/R/site-library/RInside/include/lib -Wl,-rpath=/usr/lib/R/site-library/RInside/include/lib -L${R_HOME}/lib -Wl,-rpath=${R_HOME}/lib -L/home/akhila/deepstate/src/lib -Wl,-rpath=/home/akhila/deepstate/src/lib -lR -lRInside -ldeepstate")
  write(flags,makefile.name,append = TRUE)
  write(paste(test_harness,":",makefile.name.o),makefile.name,append = TRUE)
  compile.line <- paste("\t","clang++ -o",test_harness,"${COMMON_FLAGS}")
  obj.file.path <-gsub(" ","",paste(package_name,"/src/*.o"))
  write(paste(compile.line,obj.file.path),makefile.name,append = TRUE)
  write(paste0("\t","./",test_harness," --fuzz"),makefile.name,append = TRUE)
  write(paste(makefile.name.o,":",makefile.name.cpp),makefile.name,append = TRUE)
  write(paste("\t","clang++ -I${R_HOME}/include -I/home/akhila/deepstate/src/include -I/usr/lib/R/site-library/Rcpp/include -I/usr/lib/R/site-library/RInside/include -I/home/akhila/R/RcppDeepState/inst/include/", 
              makefile.name.cpp,"-o",makefile.name.o,"-c"),makefile.name,append = TRUE)
}

create_makefile <-function(package,fun_name){
  package_name <- package
  makefile.name <- gsub("rcpp_","",paste0(fun_name,".Makefile"))
  test_harness <- gsub("rcpp_","",paste0(fun_name,"_DeepState_TestHarness"))
  makefile.name.o <-paste0(test_harness,".o")
  makefile.name.cpp <-paste0(test_harness,".cpp")
  file.create((makefile.name), recursive=TRUE)
  path <-paste("R_HOME=",R.home())
  write(path,makefile.name,append = TRUE) 
  flags <- paste0("COMMON_FLAGS =",makefile.name.o,"-I",system.file("include",package="RcppDeepState"),"-L/usr/local/lib/R/site-library/RInside/lib -Wl,-rpath=/usr/local/lib/R/site-library/RInside/lib -L${R_HOME}/lib -Wl,-rpath=${R_HOME}/lib","-L",system.file("/include/deepstate",package="RcppDeepState"),"-Wl -rpath=",system.file("/include/deepstate",package="RcppDeepState")," -lR -lRInside -ldeepstate")
  write(flags,makefile.name,append = TRUE)
  write(paste(test_harness,":",makefile.name.o),makefile.name,append = TRUE)
  compile.line <- paste("\t","clang++ -o",test_harness,"${COMMON_FLAGS}")
  obj.file.path <-gsub(" ","",paste(package_name,"/src/*.o"))
  write(paste(compile.line,obj.file.path),makefile.name,append = TRUE)
  write(paste0("\t","./",test_harness," --fuzz"),makefile.name,append = TRUE)
  write(paste(makefile.name.o,":",system.file(paste0("RcppDeepStatefiles/packagename/",makefile.name.cpp),package="RcppDeepState")),makefile.name,append = TRUE)
  write(paste("\t","clang++ -I${R_HOME}/include -I/usr/lib/R/site-library/Rcpp/include -I/usr/lib/R/site-library/RInside/include -I/home/akhila/R/RcppDeepState/inst/include/", 
                          system.file(paste0("RcppDeepStatefiles/packagename/",makefile.name.cpp),package="RcppDeepState"),"-o",makefile.name.o,"-c"),makefile.name,append = TRUE)
}
