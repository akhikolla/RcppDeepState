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
  inst_path <- file.path(package_name, "inst")
  if(!dir.exists(inst_path)){
    dir.create(inst_path)
  }
  test_path <- file.path(inst_path,"testfiles")
  packagename <- basename(package_name)
  test.files <- Sys.glob(paste0(test_path,"/*"))
  if(max_inputs != "all"){
    test.files <- test.files[1:max_inputs]
  } 
  for(pkg.i in seq_along(test.files)){
    deepstate_analyze_fun(test.files[[pkg.i]],max_inputs)
  }
}


globalVariables(c("argument.name","funName","argument.type","calls"
                  ,"code","funName",".","error.i","src.file.lines",
                  "heapsum","file.line","arg.name","value",":=",".N","f","fun_name"
                  ,"read.table","new.i.vec","download.file","result","inputs",
                  "rest","status","fun","max_inputs","pkg.list"))

globalVariables(c("error.i","error.type","sanitizer","function.i",
                  "src.file.lines","heapsum","file.line","arg.name",
                  "value",".N",":=","prototype"))

