##' @title Analyze Harness for the Package
##' @param path path of the test package to analyze
##' @param max_inputs maximum number of inputs to run on the executable under valgrind. defaults to all
##' @param testfiles number of functions to analyze in the package
##' @description Analyze all the function specific testharness in the package under valgrind.
##' @examples
##' path <- system.file("testpkgs/testSAN", package = "RcppDeepState")
##' analyzed.harness <- deepstate_harness_analyze_pkg(path)
##' print(analyzed.harness)
##' @return A list of data tables with inputs, error messages, address trace and line numbers for specified testfiles.
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
      list_testfiles[basename(test.files[[pkg.i]])] <- list(deepstate_analyze_fun(path,basename(test.files[[pkg.i]]),max_inputs))
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

##' @title analyze the binary file 
##' @param logtable.list logtable  column of result table
##' @export
issues.table <- function(logtable.list){
  logtable.list <- do.call(rbind, logtable.list)
  logtable.list.unique <-unique(logtable.list, incomparables = FALSE)
  print(logtable.list.unique)
}
##' @title analyze the binary file 
##' @param inputs.column inputs column of result table
##' @export
inputs.table <- function(inputs.column){
  inputs.list <- do.call(rbind, inputs.column)
  inputs.list.unique <-unique(inputs.list, incomparables = FALSE)
  print(inputs.list.unique)
}



##' @title analyze the binary file 
##' @param test_function path of the test function
##' @param seed input seed to pass on the executable
##' @param time.limit.seconds duration to run the code
##' @export
deepstate_fuzz_fun_analyze<- function(test_function,seed=-1,time.limit.seconds) {
  test_function <- normalizePath(test_function,mustWork = TRUE)
  fun_name <- basename(test_function)
  seed_log_analyze <- data.table()
  inputs_list<- list()
  output_folder <- file.path(test_function,paste0(time.limit.seconds,"_",seed))
  if(!dir.exists(output_folder)){
    dir.create(output_folder)
  }
  inputs.path <- Sys.glob(file.path(test_function,"inputs/*"))
  test_harness.o <- file.path(test_function, paste0(fun_name, "_DeepState_TestHarness.o"))
  log_file <- file.path(output_folder,paste0(seed,"_log"))
  valgrind.log.text <- file.path(output_folder,"seed_valgrind_log_text")
  if(!file.exists(test_harness.o)){
    deepstate_compile_fun(test_function)
  }
  if(time.limit.seconds <= 0){
    stop("time.limit.seconds should always be greater than zero")
  }
  run.executable <- if(seed == -1 && time.limit.seconds != -1){
    paste0("cd ",test_function," && valgrind --xml=yes --xml-file=",log_file,
           " --tool=memcheck --leak-check=yes --track-origins=yes ",
           "./",basename(test_function),"_DeepState_TestHarness --timeout=",time.limit.seconds,
           " --fuzz"," > ",valgrind.log.text," 2>&1")
  }else{
    paste0("cd ",test_function," && valgrind --xml=yes --xml-file=",log_file,
           " --tool=memcheck --leak-check=yes --track-origins=yes ",
           "./",basename(test_function),"_DeepState_TestHarness --seed=",seed,
           " --timeout=",time.limit.seconds," --fuzz"," > ",valgrind.log.text," 2>&1")
  }
  message(sprintf("running the executable .. \n%s\n",run.executable))
  system(run.executable)
  for(inputs.i in seq_along(inputs.path)){
    file.copy(inputs.path[[inputs.i]],output_folder)
    if(grepl(".qs",inputs.path[[inputs.i]],fixed = TRUE)){
      inputs_list[[gsub(".qs","",basename(inputs.path[[inputs.i]]))]] <- qread(inputs.path[[inputs.i]])
    }else{
      inputs_list[[basename(inputs.path[[inputs.i]])]] <-scan(inputs.path[[inputs.i]],quiet = TRUE)
    }
  }
  logtable <- deepstate_read_valgrind_xml(log_file)
  seed_log_analyze <- data.table(inputs=list(inputs_list),logtable=list(logtable))
  return(seed_log_analyze)
}


