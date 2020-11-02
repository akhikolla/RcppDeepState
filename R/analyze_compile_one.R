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

##' @title  compile the  for one function 
##' @param fun_path function path to run
##' @export
deepstate_fuzz_fun<-function(fun_path){
  fun_name <- basename(fun_path)
  log_file_path <- file.path(fun_path,paste0(fun_name,"_log"))
  test_harness.o <- file.path(fun_path, paste0(fun_name, "_DeepState_TestHarness.o"))
  test_harness_path <- file.path(fun_path,paste0(fun_name,"_DeepState_TestHarness"))
  test_harness <- paste0(fun_name,"_DeepState_TestHarness")
  run.executable <- paste0("cd ",fun_path," && ","./",test_harness,
                           " --fuzz --fuzz_save_passing --output_test_dir ",file.path(fun_path,paste0(fun_name,"_output")),
                           " > ",paste0(log_file_path,"_text "),"2>&1 ; head ", paste0(log_file_path,"_text")," > /dev/null")
  #print(run.executable)
  
  if(!file.exists(test_harness.o)){
    deepstate_compile_fun(fun_path)
  }
  cat(sprintf("running the executable .. \n%s\n",run.executable))
  system(run.executable)
  execution <- if(file.exists(test_harness_path)){
    basename(fun_path)
  }else{
    "failed"
  }
  
}


