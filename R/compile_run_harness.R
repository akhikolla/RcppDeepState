##' @title compiles the code for created testharness in package
##' @param package_name to the RcppExports file
##' @export
deep_harness_compile_run <- function(package_name){
  functions.list  <- get_function_body(package_name)
  fun_names <- unique(functions.list$funName)
  val = 0
  for(f in fun_names){
    functions.rows  <- functions.list[functions.list$funName == f,]
    makefilepath <- system.file("testfiles/testUBSAN/", package = "RcppDeepState")
    #("R/RcppDeepState/inst/RcppDeepState/testUBSAN/") 
    
    #Sys.glob(file.path(package_name,"inst","include"))here::here("R/RcppDeepState/inst/RcppDeepState/testUBSAN/")
    fun <-gsub("rcpp_","",f)
    compile_line <-paste0("rm -f *.o && make -f ",
                          system.file("testfiles/testSAN/", package = "RcppDeepState"),"/",fun,
                          ".Makefile "
    )
    print(compile_line) 
    #system(compile_line)
    if(system(compile_line) == 0)val=val+1
  }   
  if(val == length(fun_names)) 
    return("code compiled")
  else
    return("code did not compile")
} 

