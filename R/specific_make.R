##' @title  creates makefiles for above created testharness in package
##' @param package to the RcppExports file
##' @param fun_name name of function to get makefile
##' @export
create_specific_makefile <-function(package,fun_name){
  package_name <- package
  makefile.name <- gsub("rcpp_","",paste0(fun_name,".Makefile"))
  test_harness <- gsub("rcpp_","",paste0(fun_name,"_DeepState_TestHarness"))
  makefile.name.o <-paste0(test_harness,".o")
  makefile.name.cpp <-paste0(test_harness,".cpp")
  file.create((makefile.name), recursive=TRUE)
  path <-paste("R_HOME=",R.home())
  write(path,makefile.name,append = TRUE) 
  flags <- paste0("COMMON_FLAGS =",makefile.name.o," -I",system.file("include",package="RcppDeepState")," -L/usr/local/lib/R/site-library/RInside/lib -Wl,-rpath=/usr/local/lib/R/site-library/RInside/lib -L${R_HOME}/lib -Wl,-rpath=${R_HOME}/lib"," -L",system.file("/include/deepstate",package="RcppDeepState")," -Wl,-rpath=",system.file("/include/deepstate",package="RcppDeepState")," -lR -lRInside -ldeepstate")
  write(flags,makefile.name,append = TRUE)
  write(paste(test_harness,":",makefile.name.o),makefile.name,append = TRUE)
  compile.line <- paste("\t","clang++ -o",test_harness,"${COMMON_FLAGS}")
  obj.file.path <-gsub(" ","",paste0(system.file(paste0("testpkgs","/",package_name),package = "RcppDeepState"),"/src/*.o"))
  write(paste(compile.line,obj.file.path),makefile.name,append = TRUE)
  write(paste0("\t","./",test_harness," --fuzz"),makefile.name,append = TRUE)
  write(paste(makefile.name.o,":",system.file(paste0("RcppDeepStatefiles/",package_name,"/",makefile.name.cpp),package="RcppDeepState")),makefile.name,append = TRUE)
  write(paste0("\t","clang++ -I${R_HOME}/include -I/usr/lib/R/site-library/Rcpp/include -I/usr/lib/R/site-library/RInside/include"," -I",system.file("include",package="RcppDeepState")," ", 
                          system.file(paste0("RcppDeepStatefiles/",package_name,"/",makefile.name.cpp),package="RcppDeepState")," -o ",makefile.name.o," -c"),makefile.name,append = TRUE)
}
