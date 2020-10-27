##' @title  analyze the binary file 
##' @param path to test
##' @param max_inputs no of bin files to analyze
##' @param testfiles no of test files to test
##' @return returns a list of all the param values of the arguments of function
##' @import methods
##' @import Rcpp
##' @import RInside
##' @import qs
##' @export
deepstate_harness_analyze_pkg <- function(path,testfiles="all",max_inputs="all"){
  path <-normalizePath(path, mustWork=TRUE)
  package_name <- sub("/$","",path)
  list_testfiles <- list()
  inst_path <- file.path(package_name, "inst")
  if(!dir.exists(inst_path)){
    dir.create(inst_path)
  }
  test_path <- file.path(inst_path,"testfiles")
  if(file.exists(test_path)){
  packagename <- basename(package_name)
  test.files <- Sys.glob(paste0(test_path,"/*"))
  if(testfiles != "all"){
    test.files <- test.files[1:testfiles]
  }
  for(pkg.i in seq_along(test.files)){
    list_testfiles[basename(test.files[[pkg.i]])] <- list(deepstate_analyze_fun(test.files[[pkg.i]],max_inputs))
   }
  list_testfiles <- do.call(rbind,list_testfiles)
 # print(list_testfiles)
  return(list_testfiles)
  }
  else{
    message(sprintf("Please make a call to deepstate_harness_compile_run()"))
    return(message(sprintf("Testharness doesn't exists for package %s\n:",basename(path))))
   
  }
}


##' @title  analyze the binary file 
##' @param test_function path of the test package
##' @param seed input seed to pass on the executable
##' @param time.limit.seconds duration to run the code
##' @export
rcppdeepstate_compile_run_analyze<- function(test_function,seed,time.limit.seconds) {
  test_function <- normalizePath(test_function,mustWork = TRUE)
  log_file <- file.path(test_function,paste0(seed,"_log"))
  valgrind.log.text <- file.path(test_function,"valgrind_log_text")
  system(paste0("cd ",test_function," && valgrind --xml=yes --xml-file=",log_file," --tool=memcheck --leak-check=yes --track-origins=yes ",
         "./",basename(test_function),"_DeepState_TestHarness --seed=",seed," --timeout=",time.limit.seconds," --fuzz"," > ",valgrind.log.text," 2>&1"))
  seed_log_analyze=deepstate_xmlog(log_file)
  return(seed_log_analyze)
}