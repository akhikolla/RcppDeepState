##' @title Harness execution for the function
##' @param package_path path to the testpackage
##' @param fun_name name of the function to compile
##' @param seed input seed value to pass on the executable
##' @param time.limit.seconds duration to run the executable
##' @param sep default to infun
##' @description Executes the function-specific testharness in the package.
##' @examples
##' package_path <- system.file("testpkgs/testSAN", package = "RcppDeepState")
##' fun_name <- "rcpp_read_out_of_bound"
##' compiled.harness <- deepstate_fuzz_fun(package_path,fun_name)
##' print(compiled.harness)
##' #Runs the harness specified number of seconds
##' compiled.harness.timer <- deepstate_fuzz_fun(package_path,fun_name,time.limit.seconds=6)
##' print(compiled.harness.timer)
##' @return The executed function.
##' @export
deepstate_fuzz_fun<-function(package_path,fun_name,seed=-1,time.limit.seconds=2,sep="infun"){
  if(!dir.exists(file.path(package_path,"inst/testfiles"))){
    stop("Missing testfiles directory")
  }
  fun_path <- file.path(package_path,"inst/testfiles",fun_name)
  if(dir.exists(fun_path)){
  fun_path <-normalizePath(fun_path,mustWork = TRUE)
  }
  if(sep == "generation" || sep == "checks"){
    log_file_path <- file.path(fun_path,paste0(fun_name,"_",sep,"_log"))
    test_harness.o <- file.path(fun_path, paste0(fun_name, "_DeepState_TestHarness_",sep,".o"))
    test_harness_path <- file.path(fun_path,paste0(fun_name,"_DeepState_TestHarness_",sep))
    test_harness <- paste0(fun_name,"_DeepState_TestHarness_",sep)
    output_dir <- file.path(fun_path,paste0(fun_name,"_output","_",sep))
  }else{
    log_file_path <- file.path(fun_path,paste0(fun_name,"_log"))
    test_harness.o <- file.path(fun_path, paste0(fun_name, "_DeepState_TestHarness.o"))
    test_harness_path <- file.path(fun_path,paste0(fun_name,"_DeepState_TestHarness"))
    test_harness <- paste0(fun_name,"_DeepState_TestHarness")
    output_dir <- file.path(fun_path,paste0(fun_name,"_output"))
  }
  if(!file.exists(test_harness.o)){
    print(fun_path)
    deepstate_compile_fun(fun_path,sep)
  }
  ## If time.limit.seconds is lessthan or equal to zero we return NULL
  if(time.limit.seconds <= 0){
    stop("time.limit.seconds should always be greater than zero")
  }
  run.executable <-  if(seed == -1 && time.limit.seconds == -1){
    paste0("cd ",fun_path," && ","./",test_harness,
           " --fuzz --fuzz_save_passing --output_test_dir ",output_dir,
           " > ",log_file_path,"_text 2>&1 ; head ", log_file_path,"_text"," > /dev/null")
  }else if(seed == -1 && time.limit.seconds != -1){
    paste0("cd ",fun_path," && ","./",test_harness," --timeout=",time.limit.seconds,
           " --fuzz --fuzz_save_passing --output_test_dir ",output_dir,
           " > ",log_file_path,"_text 2>&1 ; head ", log_file_path,"_text"," > /dev/null")
  }else{
    paste0("cd ",fun_path," && ","./",test_harness," --seed=",seed," --timeout=",time.limit.seconds,
           " --fuzz --fuzz_save_passing --output_test_dir ",output_dir,
           " > ",log_file_path,"_text 2>&1 ; head ", log_file_path,"_text"," > /dev/null")
  }
  
  #print(run.executable)
  cat(sprintf("running the executable .. \n%s\n",run.executable))
  system(run.executable)
  execution <- if(file.exists(test_harness.o) && file.exists(test_harness_path)){
    basename(fun_path)
  }else{
    NA_character_
  }
}


