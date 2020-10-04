##' @title compiles the code for created testharness in package
##' @param package_name to the RcppExports file
##' @param max_inputs number of bin files to analyze
##' @export
deepstate_harness_compile_run <- function(package_name,max_inputs="all"){
  package_name <- normalizePath(package_name, mustWork=TRUE)
  package_name <- sub("/$","",package_name)
  inst_path <- file.path(package_name, "inst")
  test_path <- file.path(inst_path,"testfiles")
  uncompiled.code <- list()
  functions.list  <-  RcppDeepState::deepstate_get_function_body(package_name)
  #create_testpkgs_objects()
  if(!is.null(functions.list) && length(functions.list) > 1){
  functions.list$argument.type<-gsub("Rcpp::","",functions.list$argument.type)
  fun_names <- unique(functions.list$funName)
  uncompiled_count = 0
  log_count = 0
  for(f in fun_names){
    functions.rows  <- functions.list[functions.list$funName == f,]
    params <- c(functions.rows$argument.type)
    if( RcppDeepState::deepstate_datatype_check(params) == 1){
    fun_path <- file.path(test_path,f)
    compile_line <-paste0("cd ",fun_path," && rm -f *.o && make\n")
    #print(paste0(fun_path,"/","Makefile"))
    #print(paste0(fun_path,"/",f,"_log"))
    #system(compile_line)
    if(file.exists(paste0(fun_path,"/",f,"_DeepState_TestHarness.cpp")) && 
       file.exists(paste0(fun_path,"/","Makefile"))){
      cat(sprintf(compile_line))
         system(compile_line)
    }
    else {
      message(sprintf("TestHarness and makefile doesn't exist for - %s\n",f))
    }
    if(!file.exists(paste0(fun_path,"/",f,"_DeepState_TestHarness"))){
       uncompiled_count  = uncompiled_count + 1
       uncompiled.code <- c(uncompiled.code,f)
        #cat(sprintf("Couldn't compile - %s\n", f))
    }
    else{
     if(file.exists(paste0(fun_path,"/",f,"_log")))
       log_count = log_count + 1 
    }
  }
  }
  deepstate_harness_analyze_pkg(package_name,max_inputs)
 }
    if(uncompiled_count == 0 && log_count == length(fun_names) ) 
    return("Compiled all the functions in the package successfully")
  else
    return(paste0("Issue compiling the functions ",uncompiled.code))
  

}


