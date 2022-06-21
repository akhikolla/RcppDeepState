##' @title Harness Makefile Generation
##' @param package path to the test package
##' @param fun_name name of the function
##' @description This function generates makefile for the provided function specific TestHarness
##' @export
deepstate_create_makefile <-function(package,fun_name){
  #list.paths <-nc::capture_first_vec(package, "/",root=".+?","/",remain_path=".*")
  inst_path <- file.path(package, "inst")
  #p <- nc::capture_all_str(list.paths$remain_path,val=".+/",folder=".+/",packagename=".*")
  test_path <- file.path(inst_path,"testfiles")
  fun_path <- file.path(test_path,fun_name)
  log_file_path <- file.path(fun_path,paste0(fun_name,"_log"))

  test_harness <- paste0(fun_name,"_DeepState_TestHarness")
  makefile_path <- file.path(fun_path, "Makefile")
  test_harness.o <- paste0(test_harness,".o")
  test_harness.cpp <- paste0(test_harness,".cpp")
  test_harness.o_path <- file.path(fun_path,test_harness.o)
  test_harness.cpp_path <- file.path(fun_path,test_harness.cpp)
  test_harness_path <- file.path(fun_path,test_harness)
  file.create(makefile_path, recursive=TRUE)

  # R home, include and lib directories
  path_home <-paste0("R_HOME=",R.home())
  path_include <-paste0("R_INCLUDE=",R.home("include"))
  path_lib <-paste0("R_LIB=",R.home("lib"))
  write_to_file <- paste0(path_home,"\n",path_include,"\n",path_lib,"\n\n")
  
  # include and lib path locations
  rcpp_include <- system.file("include", package="RcppDeepState")
  rcppdeepstate_include <- system.file("include", package="Rcpp")
  rcpparmadillo_include <- system.file("include", package="RcppArmadillo")
  rinside_include <- system.file("include", package="RInside")
  deepstate_path <- file.path("${HOME}", ".RcppDeepState", "deepstate-master")
  deepstate_build <- file.path(deepstate_path, "build")
  deepstate_include <- file.path(deepstate_path, "src", "include")
  qs_include <- system.file("include", package="qs")
  rinside_lib <- system.file("lib", package="RInside")

  # CPPFLAGS : headers inclusion
  compiler_cppflags <- paste0("-I", rcpp_include) 
  compiler_cppflags <- paste(compiler_cppflags, paste0("-I", rcppdeepstate_include)) 
  compiler_cppflags <- paste(compiler_cppflags, paste0("-I", rcpparmadillo_include)) 
  compiler_cppflags <- paste(compiler_cppflags, paste0("-I", rinside_include)) 
  compiler_cppflags <- paste(compiler_cppflags, paste0("-I", deepstate_build))
  compiler_cppflags <- paste(compiler_cppflags, paste0("-I", deepstate_include)) 
  compiler_cppflags <- paste(compiler_cppflags, paste0("-I", qs_include)) 
  compiler_cppflags <- paste(compiler_cppflags, paste0("-I", "${R_INCLUDE}"))
  write_to_file <- paste0(write_to_file, "CPPFLAGS=",compiler_cppflags, "\n")

  # LDFLAGS : libs inclusion
  compiler_ldflags <- paste0("-L", rinside_lib, " -Wl,-rpath=", rinside_lib) 
  compiler_ldflags <- paste(compiler_ldflags, "-L${R_LIB} -Wl,-rpath=${R_LIB}")
  compiler_ldflags <- paste(compiler_ldflags, paste0("-L", deepstate_build, " -Wl,-rpath=", deepstate_build))
  write_to_file <- paste0(write_to_file, "LDFLAGS=", compiler_ldflags, "\n")

  # LDLIBS : library flags for the linker
  compiler_ldlibs <- paste("-lR", "-lRInside", "-ldeepstate")
  write_to_file <- paste0(write_to_file, "LDLIBS=",compiler_ldlibs, "\n\n")

  # install.packages(setdiff(basename(package), rownames(installed.packages())),repos = "http://cran.us.r-project.org")
  dir.create(file.path(fun_path, paste0(fun_name,"_output")), showWarnings = FALSE)

  obj.file.list <- Sys.glob(file.path(package,"src/*.so"))
  obj.file.path <- obj.file.list
  if(length(obj.file.list) <= 0){
    obj.file.path<-file.path(package,"src/*.cpp")  
  }
  objs.add <- file.path(package,paste0("src/", fun_name, ".o"))
 
  # Makefile rules : compile lines
  write_to_file<-paste0(write_to_file, "\n\n", test_harness_path, " : ", test_harness.o_path)
  write_to_file<-paste0(write_to_file, "\n\t", "clang++ -g ", test_harness.o_path, " ${CPPFLAGS} ", " ${LDFLAGS} ", " ${LDLIBS} ", obj.file.path, " -o ", test_harness_path) #," ",objs.add)
  write_to_file<-paste0(write_to_file, "\n\n", test_harness.o_path, " : ", test_harness.cpp_path)
  write_to_file<-paste0(write_to_file, "\n\t", "clang++ -g -c ", " ${CPPFLAGS} ", test_harness.cpp_path, " -o ", test_harness.o_path)
  
  write(write_to_file, makefile_path, append=TRUE)
}
