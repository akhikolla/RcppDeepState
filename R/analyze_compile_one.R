##' @title  compile the  for one function 
##' @param fun_path function path to run
##' @export
deepstate_compile_fun<-function(fun_path){
  compile_line <-paste0("cd ",fun_path," && rm -f *.o && make\n")
  if(file.exists(file.path(fun_path,paste0(basename(fun_path),"_DeepState_TestHarness.cpp"))) && 
     file.exists(file.path(fun_path,"Makefile"))){
    cat(sprintf("executing .. \n%s\n",compile_line))
    system(compile_line)
    if(file.exists(file.path(fun_path, paste0(basename(fun_path), "_DeepState_TestHarness")))){
      #deepstate_analyze_fun(fun_path,max_inputs)
      return(basename(fun_path))
    }
    else{
      return("failed")
    } 
  }
  
}
