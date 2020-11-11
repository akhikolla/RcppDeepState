##' @title  compile the  for one function 
##' @param fun_path function path to run
##' @export
deepstate_compile_fun<-function(fun_path){
  compile_line <-paste0("cd ",fun_path," && rm -f *.o && make\n")
  if(file.exists(file.path(fun_path,paste0(basename(fun_path),"_DeepState_TestHarness.cpp"))) && 
     file.exists(file.path(fun_path,"Makefile"))){
    cat(sprintf("compiling .. \n%s\n",compile_line))
    system(compile_line)
  }else{
    message(sprintf("TestHarness and makefile doesn't exists. Please use deepstate_pkg_create() to create them"))
  }
}

##' @title analyze the binary file 
##' @param fun_path path of the test package function
##' @param seed input seed to pass on the executable
##' @param time.limit.seconds duration to run the code
##' @export
deepstate_fuzz_fun<-function(fun_path,seed=-1,time.limit.seconds=0){
  fun_name <- basename(fun_path)
  log_file_path <- file.path(fun_path,paste0(fun_name,"_log"))
  test_harness.o <- file.path(fun_path, paste0(fun_name, "_DeepState_TestHarness.o"))
  test_harness_path <- file.path(fun_path,paste0(fun_name,"_DeepState_TestHarness"))
  test_harness <- paste0(fun_name,"_DeepState_TestHarness")
  ## If time.limit.seconds is lessthan or equal to zero we return NULL
  if(time.limit.seconds < 0){
    stop("time.limit.seconds should always be greater than zero")
  }
  run.executable <-  if(seed == -1 && time.limit.seconds == -1){
              paste0("cd ",fun_path," && ","./",test_harness,
                           " --fuzz --fuzz_save_passing --output_test_dir ",file.path(fun_path,paste0(fun_name,"_output")),
                           " > ",log_file_path,"_text 2>&1 ; head ", log_file_path,"_text"," > /dev/null")
  }else if(seed == -1 && time.limit.seconds != -1){
    paste0("cd ",fun_path," && ","./",test_harness," --timeout=",time.limit.seconds,
           " --fuzz --fuzz_save_passing --output_test_dir ",file.path(fun_path,paste0(fun_name,"_output")),
           " > ",log_file_path,"_text 2>&1 ; head ", log_file_path,"_text"," > /dev/null")
  }else{
    paste0("cd ",fun_path," && ","./",test_harness," --seed=",seed,"--timeout=",time.limit.seconds,
           " --fuzz --fuzz_save_passing --output_test_dir ",file.path(fun_path,paste0(fun_name,"_output")),
           " > ",log_file_path,"_text 2>&1 ; head ", log_file_path,"_text"," > /dev/null")
  }
  
  #print(run.executable)
  if(!file.exists(test_harness.o)){
    deepstate_compile_fun(fun_path)
  }
  cat(sprintf("running the executable .. \n%s\n",run.executable))
  system(run.executable)
  execution <- if(file.exists(test_harness.o) && file.exists(test_harness_path)){
    basename(fun_path)
  }else{
    NA_character_
  }
}


