##' @title TestHarness for the package
##' @param package_path path to the test package
##' @description Creates Testharness for all the functions in the package that you want to test
##' using RcppDeepState.
##' @examples 
##' path <- system.file("testpkgs/testSAN", package = "RcppDeepState")
##' harness.list <- deepstate_pkg_create(path)
##' print(harness.list)
##' @import RcppArmadillo
##' @return A character vector of TestHarness files that are generated
##' @export
deepstate_pkg_create<-function(package_path){
  package_path <-normalizePath(package_path, mustWork=TRUE)
  package_path <- sub("/$","",package_path)
  inst_path <- file.path(package_path, "inst")
  if(!dir.exists(inst_path)){
    dir.create(inst_path)
  }
  test_path <- file.path(inst_path,"testfiles")
  packagename <- basename(package_path)
  unlink(test_path, recursive = TRUE)
  if(!file.exists(file.path(package_path,"src/*.so"))){
    system(paste0("R CMD INSTALL ",package_path),intern = FALSE,ignore.stderr =TRUE,ignore.stdout = TRUE)
  }
  if(!(file.exists("~/.RcppDeepState/deepstate-master/build/libdeepstate32.a") &&
       file.exists("~/.RcppDeepState/deepstate-master/build/libdeepstate.a")))
  {
    RcppDeepState::deepstate_make_run()
  }
  dir.create(test_path,showWarnings = FALSE)
  Rcpp::compileAttributes(package_path)
  harness <- list()
  failed.harness <- list()
  primitives <- list()
  functions.list <-  RcppDeepState::deepstate_get_function_body(package_path)
  if(!is.null(functions.list) && length(functions.list) > 1){
    functions.list$argument.type<-gsub("Rcpp::","",functions.list$argument.type)
    prototypes_calls <-deepstate_get_prototype_calls(package_path)
    in_package <- paste0("RcppDeepState")
    match_count = 0
    mismatch_count = 0
    #dir.create(file.path(inst_path,"testfiles"))
    headers <-"#include <fstream>\n#include <RInside.h>\n#include <iostream>\n#include <RcppDeepState.h>\n#include <qs.h>\n#include <DeepState.hpp>\n"
    #include <-gsub("@","\"",includes)
    fun_names <- unique(functions.list$funName)
    for(function_name.i in fun_names){
      functions.rows  <- functions.list [functions.list$funName == function_name.i,]
      params <- c(functions.rows$argument.type)
      filepath <-deepstate_fun_create(package_path,function_name.i)
      filename <- paste0(function_name.i,"_DeepState_TestHarness",".cpp")
      if(!is.na(filepath) && basename(filepath) ==  filename ){
        match_count = match_count + 1
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
      message(sprintf("Testharness created for %d functions in the package\n",match_count))
      return(as.character(harness))
    }
    else{
      if(mismatch_count < length(fun_names) && length(failed.harness) > 0 && match_count != 0){
        message(sprintf("Failed to create testharness for %d functions in the package - %s\n",mismatch_count,paste(failed.harness, collapse=", ")))
        message(sprintf("Testharness created for %d functions in the package\n",match_count))
        return(as.character(harness))
      }  
    }
    if(mismatch_count == length(fun_names)){
      stop("Testharnesses cannot be created for the package - datatypes fall out of specified list!!")
      return(as.character(failed.harness))
    }
  }
  else{
    stop("No Rcpp Functions to test in the package")
  }
}   
