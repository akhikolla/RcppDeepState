##' @title compiles the code for created testharness in package
##' @param package_name to the RcppExports file
##' @export
deepstate_harness_compile_run <- function(package_name){
  inst_path <- file.path(package_name, "inst")
  test_path <- file.path(inst_path,"testfiles")
  functions.list  <- deepstate_get_function_body(package_name)
  #create_testpkgs_objects()
  functions.list$argument.type<-gsub("Rcpp::","",functions.list$argument.type)
  fun_names <- unique(functions.list$funName)
  val = 0
  for(f in fun_names){
    functions.rows  <- functions.list[functions.list$funName == f,]
    params <- c(functions.rows$argument.type)
    if(deepstate_datatype_check(params) == 1){
    fun <-gsub("rcpp_","",f)
    compile_line <-paste0("rm -f *.o && make -f ",test_path,"/",fun,
                          ".Makefile ")
    print(compile_line) 
    #system(compile_line)
    if(system(compile_line) == 1){
       val = val + 1 
       cat(sprintf("Couldn't compile - %s\n", f))
    }
  }
  }
  if(val == 0) return("Compiled all the functions in the package successfully")
} 

