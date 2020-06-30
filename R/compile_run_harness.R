##' @title compiles the code for created testharness in package
##' @param package_name to the RcppExports file
##' @export
deep_harness_compile_run <- function(package_name){
  inst_path <- file.path(package_name, "inst")
  test_path <- file.path(inst_path,"testfiles")
  functions.list  <- get_function_body(package_name)
  functions.list$argument.type<-gsub("Rcpp::","",functions.list$argument.type)
  fun_names <- unique(functions.list$funName)
  val = 0
  for(f in fun_names){
    functions.rows  <- functions.list[functions.list$funName == f,]
    #makefilepath <- system.file("testfiles/testUBSAN/", package = "RcppDeepState")
    #("R/RcppDeepState/inst/RcppDeepState/testUBSAN/") 
    
    #Sys.glob(file.path(package_name,"inst","include"))here::here("R/RcppDeepState/inst/RcppDeepState/testUBSAN/")
    fun <-gsub("rcpp_","",f)
    compile_line <-paste0("rm -f *.o && make -f ",test_path,"/",fun,
                          ".Makefile ")
    print(compile_line) 
    #system(compile_line)
    if(system(compile_line) == 0)val=val+1
  }   
  if(val == length(fun_names)) 
    return("code compiled")
  else
    return("code did not compile")
} 
