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
  print(length(testharness))
  print(testharness)
  functions.list <- Sys.glob(file.path(test_path,"*"))
  print(length(basename(functions.list)))
  print(functions.list)
  if(length(testharness) == length(basename(functions.list))){
    #if(length(functions.list) >= 1){
    uncompiled_count = 0
    log_count = 0
    for(fun.path in functions.list){
        compile.res <- deepstate_compile_fun(fun.path)
        if(compile.res == basename(fun.path)){
          compiled.code <-c(compiled.code,compile.res)
        }
        else{
           uncompiled.code <- c(uncompiled.code,basename(fun.path))
           message(sprintf("%s\n",compile.res))
          }
    }
    return(as.character(compiled.code))
    #}
}
  else{
    print("failed")
  }
  
}
  


