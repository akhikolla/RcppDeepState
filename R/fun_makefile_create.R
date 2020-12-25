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
  write_to_file <- ""
  makefile.name <-paste0("Makefile")
  test_harness <- paste0(fun_name,"_DeepState_TestHarness")
  makefile_path <- file.path(fun_path,makefile.name)
  makefile.name.o <-paste0(test_harness,".o")
  makefile.name.cpp <-paste0(test_harness,".cpp")
  makefile.o_path<-file.path(fun_path,makefile.name.o)
  makefile.cpp_path<-file.path(fun_path,makefile.name.cpp)
  test_harness_path <- file.path(fun_path,test_harness)
  file.create(makefile_path, recursive=TRUE)
  path <-paste("R_HOME=",dirname(R.home('include')))
  write_to_file<-paste0(write_to_file,path,"\n")
  insts.path <- "${HOME}"
  deepstate.path <- file.path(insts.path,".RcppDeepState")
  master <- file.path(deepstate.path,"deepstate-master")
  deepstate.build <- file.path(master,"build")
  deepstate.header <- file.path(master,"src/include")
  flags <- paste0("COMMON_FLAGS = ",makefile.o_path," -I",
                  system.file("include",package="RcppDeepState")," -I",deepstate.build," -I",
                  deepstate.header," -L",system.file("lib", package="RInside"),
                  " -Wl,-rpath=",system.file("lib", package="RInside"),
                  " -L${R_HOME}/lib -Wl,-rpath=${R_HOME}/lib"," -L",deepstate.build,
                  " -Wl,-rpath=",deepstate.build," -lR -lRInside -ldeepstate")
  write_to_file<-paste0(write_to_file,flags)
  log_file_path <- file.path(fun_path,paste0(fun_name,"_log"))
  write_to_file<-paste0(write_to_file,"\n\n",test_harness_path," : ",makefile.o_path)
  compile.line <- paste0("\n\t","clang++ -g -o ",test_harness_path," ${COMMON_FLAGS} ","-I${R_HOME}/include -I", system.file("include", package="Rcpp")," -I",system.file("include", package="RcppArmadillo")," -I",deepstate.header," ")
  obj.file.list <-Sys.glob(file.path(package,"src/*.so"))
  obj.file.path <- obj.file.list
  if(length(obj.file.list) <= 0){
    obj.file.path<-file.path(package,"src/*.cpp")  
  }
  objs.add <-file.path(package,paste0("src/",fun_name,".o"))
  write_to_file<-paste0(write_to_file,compile.line,obj.file.path)#," ",objs.add)
  dir.create(file.path(fun_path,paste0(fun_name,"_output")), showWarnings = FALSE)
  #write_to_file<-paste0(write_to_file,"\n\t","cd ",paste0("/home/",p$val,"testfiles","/",p$packagename)," && ","./",test_harness," --fuzz")
  write_to_file<-paste0(write_to_file,"\n\n",makefile.o_path," : ",makefile.cpp_path)
  write_to_file<-paste0(write_to_file,"\n\t","clang++ -g -I${R_HOME}/include -I", system.file("include", package="Rcpp"),
                        " -I",system.file("include", package="RcppArmadillo")," -I",system.file("include", package="qs")," -I",system.file("include", package="RInside"),
                        " -I",system.file("include",package="RcppDeepState")," ",makefile.cpp_path," -o ",makefile.o_path," -c")
  write(write_to_file,makefile_path,append=TRUE)
}
