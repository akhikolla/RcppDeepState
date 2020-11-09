##' @title compiles the code for created testharness in package
##' @param package_name to the RcppExports file
##' @export
deepstate_harness_compile_run <- function(package_name){
  package_name <- normalizePath(package_name, mustWork=TRUE)
  package_name <- sub("/$","",package_name)
  inst_path <- file.path(package_name, "inst")
  test_path <- file.path(inst_path,"testfiles")
  uncompiled.code <- list()
  compiled.code <- list()
  testharness<-deepstate_pkg_create(package_name)
  testharness <- gsub("_DeepState_TestHarness.cpp","",testharness)
  functions.list <- Sys.glob(file.path(test_path,"*"))
  if(length(testharness) == length(basename(functions.list))){
    uncompiled_count = 0
    log_count = 0
    for(fun.path in functions.list){
      compile.res <- deepstate_fuzz_fun(fun.path,time.limit.seconds=2)
      if(compile.res == basename(fun.path)){
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
  else{
    stop("TestHarness are not created for all the function that are returned by pkg create")
  }
}



