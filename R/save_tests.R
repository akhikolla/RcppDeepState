##' @title  compile the code and save passing tests 
##' @param package_name for the RcppExports file
##' @export
deep_harness_save_passing_tests<-function(package_name){
  functions.list  <- get_function_body(package_name)
  fun_names <- unique(functions.list $funName)
  for(f in fun_names){
    functions.rows  <- functions.list [functions.list $funName == f,]
    fun_name <-gsub("rcpp_","",f)
    output.dir <- paste0(fun_name,"_output_pass")
    dir.create(output.dir)
    print(paste("saving passed testcases in", output.dir))
    filename <-paste0("./",fun_name,"_DeepState_TestHarness"," --fuzz --fuzz_save_passing --output_test_dir ",output.dir)
    system(filename)
  }
}
##' @title  compile the code and save crashu=ing tests 
##' @param package_name for the RcppExports file
##' @export
deep_harness_save_crash_tests<-function(package_name){
  functions.list  <- get_function_body(package_name)
  fun_names <- unique(functions.list $funName)
  for(f in fun_names){
    functions.rows  <- functions.list [functions.list$funName == f,]
    fun_name <-gsub("rcpp_","",f)
    output.dir <- paste0(fun_name,"_output_fail")
    dir.create(output.dir)
    print(paste("saving passed testcases in", output.dir))
    filename <-paste0("./",fun_name,"_DeepState_TestHarness"," --fuzz --output_test_dir ",output.dir)
    system(filename)
  }
}
