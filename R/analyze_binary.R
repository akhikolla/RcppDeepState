##' @title  analyze the binary file 
##' @param path to test
##' @param max_inputs no of bin files to analyze
##' @return returns a list of all the param values of the arguments of function
##' @import methods
##' @import Rcpp
##' @import RInside
##' @import qs
##' @export
deepstate_harness_analyze_pkg <- function(path,max_inputs="all"){
  path <-normalizePath(path, mustWork=TRUE)
  package_name <- sub("/$","",path)
  testfiles.res <- list()
  inst_path <- file.path(package_name, "inst")
  if(!dir.exists(inst_path)){
    dir.create(inst_path)
  }
  test_path <- file.path(inst_path,"testfiles")
  if(file.exists(test_path)){
  packagename <- basename(package_name)
  test.files <- Sys.glob(paste0(test_path,"/*"))
  if(max_inputs != "all"){
    test.files <- test.files[1:max_inputs]
  } 
  for(pkg.i in seq_along(test.files)){
    testfiles.res(test.files[[pkg.i]]) <- deepstate_analyze_fun(test.files[[pkg.i]],max_inputs)
  }
  testfiles.res <- do.call(rbind,testfiles.res)
  print(testfiles.res)
  return(testfiles.res)
  }
  else{
    message(sprintf("Please make a call to deepstate_harness_compile_run()"))
    return(message(sprintf("Testharness doesn't exists for package %s\n:",basename(path))))
   
  }
}


globalVariables(c("argument.name","funName","argument.type","calls"
                  ,"code","funName",".","error.i","src.file.lines",
                  "heapsum","file.line","arg.name","value",":=",".N","f","fun_name"
                  ,"read.table","new.i.vec","download.file","result","inputs",
                  "rest","status","fun","max_inputs","pkg.list","testfiles.res"))

globalVariables(c("error.i","error.type","sanitizer","function.i",
                  "src.file.lines","heapsum","file.line","arg.name",
                  "value",".N",":=","prototype"))

