##' @title Harness compilation for the function
##' @param fun_path path of the function to compile
##' @param sep default to infun
##' @description Compiles the function-specific testharness in the package.
##' @examples
##' path <- system.file("testpkgs/testSAN", package = "RcppDeepState")
##' compiled.harness <- deepstate_compile_fun(path)
##' print(compiled.harness.list)
##' @export
deepstate_compile_fun<-function(fun_path,sep="infun"){
  if(sep == "infun"){
    harness.file <- file.path(fun_path,paste0(basename(fun_path),"_DeepState_TestHarness.cpp"))
    make.file <- file.path(fun_path,"Makefile")
    compile_line <-paste0("cd ",fun_path," && rm -f *.o && make\n")
  }else if(sep == "generation"){
    harness.file <- file.path(fun_path,paste0(basename(fun_path),"_DeepState_TestHarness_generation.cpp"))
    make.file <- file.path(fun_path,"generation.Makefile")
    compile_line <-paste0("cd ",fun_path," && rm -f *.o && make -f generation.Makefile\n")
    }else if(sep == "checks"){
    harness.file <- file.path(fun_path,paste0(basename(fun_path),"_DeepState_TestHarness_checks.cpp"))
    make.file <- file.path(fun_path,"checks.Makefile")
    compile_line <-paste0("cd ",fun_path," && rm -f *.o && make -f checks.Makefile\n")
    }
  if(file.exists(harness.file) && 
     file.exists(make.file)){
    cat(sprintf("compiling .. \n%s\n",compile_line))
    system(compile_line)
  }else{
    message(sprintf("TestHarness and makefile doesn't exists. Please use deepstate_pkg_create() to create them"))
  }
}


##' @title Harness execution for the function
##' @param fun_path path of the function to compile
##' @param seed input seed value to pass on the executable
##' @param time.limit.seconds duration to run the executable
##' @param sep default to infun
##' @description Executes the function-specific testharness in the package.
##' @examples
##' path <- system.file("testpkgs/testSAN", package = "RcppDeepState")
##' compiled.harness <- deepstate_fuzz_fun(path)
##' print(compiled.harness.list)
##' @return The executed function.
##' @export
deepstate_fuzz_fun<-function(fun_path,seed=-1,time.limit.seconds=-1,sep="infun"){
  fun_name <- basename(fun_path)
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
    paste0("cd ",fun_path," && ","./",test_harness," --seed=",seed,"--timeout=",time.limit.seconds,
           " --fuzz --fuzz_save_passing --output_test_dir ",output_dir,
           " > ",log_file_path,"_text 2>&1 ; head ", log_file_path,"_text"," > /dev/null")
  }
  
  #print(run.executable)
  if(!file.exists(test_harness.o)){
    deepstate_compile_fun(fun_path,sep)
  }
  cat(sprintf("running the executable .. \n%s\n",run.executable))
  system(run.executable)
  execution <- if(file.exists(test_harness.o) && file.exists(test_harness_path)){
    basename(fun_path)
  }else{
    NA_character_
  }
}


