##' @title  creates testharness for given functions in package
##' @param package_name to the RcppExports file
##' @import RcppArmadillo
##' @export
deepstate_pkg_create<-function(package_name){
  package_name <-normalizePath(package_name, mustWork=TRUE)
  package_name <- sub("/$","",package_name)
  inst_path <- file.path(package_name, "inst")
  if(!dir.exists(inst_path)){
    dir.create(inst_path)
  }
  test_path <- file.path(inst_path,"testfiles")
  packagename <- basename(package_name)
  unlink(test_path, recursive = TRUE)
  system(paste0("R CMD INSTALL ",package_name),intern = FALSE,ignore.stderr =TRUE,ignore.stdout = TRUE)
  if(!(file.exists("~/.RcppDeepState/deepstate-master/build/libdeepstate32.a") &&
       file.exists("~/.RcppDeepState/deepstate-master/build/libdeepstate.a")))
  {
    RcppDeepState::deepstate_make_run()
  }
  dir.create(test_path,showWarnings = FALSE)
  Rcpp::compileAttributes(package_name)
  harness <- list()
  failed.harness <- list()
  functions.list <-  RcppDeepState::deepstate_get_function_body(package_name)
  if(!is.null(functions.list) && length(functions.list) > 1){
    functions.list$argument.type<-gsub("Rcpp::","",functions.list$argument.type)
    prototypes_calls <-deepstate_get_prototype_calls(package_name)
    in_package <- paste0("RcppDeepState")
    match_count = 0
    mismatch_count = 0
    #dir.create(file.path(inst_path,"testfiles"))
    #include <-gsub("@","\"",includes)
    fun_names <- unique(functions.list$funName)
    for(function_name.i in fun_names){
      
      functions.rows  <- functions.list [functions.list$funName == function_name.i,]
      params <- c(functions.rows$argument.type)
      if(RcppDeepState::deepstate_datatype_check(params) == 1){
        match_count = match_count + 1
        pt <- prototypes_calls[prototypes_calls$funName == function_name.i,]
        filename <- paste0(function_name.i,"_DeepState_TestHarness",".cpp")
        filepath <- deepstate_fun_create(package_name,functions.rows,function_name.i,pt)
        if(file.exists(filepath))
        harness <- c(harness,filename)
      }
      else if(deepstate_datatype_check(params) == 0)
      {
        mismatch_count = mismatch_count + 1
        failed.harness <- c(failed.harness,function_name.i)
        #cat(sprintf("We can't test the function - %s - due to  datatypes fall out of the specified list\n", function_name.i))
      }
    }
    
    if(match_count > 0 && match_count == length(fun_names)){
      cat(sprintf("Testharness created for %d functions in the package\n",match_count))
      return(as.character(harness))
    }
    else{
      if(mismatch_count < length(fun_names) && length(failed.harness) > 0 && match_count != 0){
        message(sprintf("Failed to create testharness for %d functions in the package - %s\n",mismatch_count,failed.harness))
        cat(sprintf("Testharness created for %d functions in the package\n",match_count))
        return(as.character(harness))
      }  
    }
    if(mismatch_count == length(fun_names)){
      message(sprintf("Testharnesses cannot be created for the package - datatypes fall out of specified list!!"))
      return(as.character(failed.harness))
    }
  }
  else{
    message(sprintf("No Rcpp Functions to test in the package"))
  }
}   
##' @title  creates makefiles for above created testharness in package
##' @param package to the RcppExports file*
##' @param fun_name name of function to get makefile
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
  obj.file.list <-Sys.glob(file.path(package_name,"src/*.o"))
  obj.file.path <- file.path(package,"src/*.o")  
  if(length(obj.file.list) <= 0){
    obj.file.path<-file.path(package,"src/*.cpp")  
  }
  #print(obj.file.path)
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