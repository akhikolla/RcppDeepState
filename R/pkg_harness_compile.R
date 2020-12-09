##' @title Harness compilation for the package
##' @param package_path to the test package
##' @param time.limit.seconds duration to run the testharness, defaulted to 5 seconds
##' @description Compiles all the generated function-specific testharness in the package.
##' @examples
##' path <- system.file("testpkgs/testSAN", package = "RcppDeepState")
##' compiled.harness.list <- deepstate_harness_compile_run(path)
##' print(compiled.harness.list)
##' @return A character vector of compiled functions.
##' @export
deepstate_harness_compile_run <- function(package_path,time.limit.seconds=5){
  if(time.limit.seconds <= 0){
    stop("time.limit.seconds should always be greater than zero")
  }
  package_path <- normalizePath(package_path, mustWork=TRUE)
  package_path <- sub("/$","",package_path)
  inst_path <- file.path(package_path, "inst")
  test_path <- file.path(inst_path,"testfiles")
  uncompiled.code <- list()
  compiled.code <- list()
  testharness<-deepstate_pkg_create(package_path)
  testharness <- gsub("_DeepState_TestHarness.cpp","",testharness)
  functions.list <- Sys.glob(file.path(test_path,"*"))
  #no harness created
  if(length(functions.list)){
    if(length(testharness) == length(basename(functions.list)) && 
       length(intersect(basename(functions.list),testharness)) == length(testharness)){
      uncompiled_count = 0
      log_count = 0
      for(fun.path in functions.list){
        compile.res <- RcppDeepState::deepstate_fuzz_fun(package_path,basename(fun.path),time.limit.seconds)
        if(!is.na(compile.res) && compile.res == basename(fun.path)){
          compiled.code <-c(compiled.code,compile.res)
        }
        else{
          uncompiled.code <- c(uncompiled.code,basename(fun.path))
        }
      }
      if(length(uncompiled.code) > 0)
        message(sprintf("Uncompiled functions : %s\n",paste(uncompiled.code, collapse=", ")))
      return(as.character(compiled.code))
    }
  }
  else{
    stop("TestHarness are not created for all the function that are returned by pkg create")
  }
}



