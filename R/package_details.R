##' @title gets package details
##' @return function list with function names and arguments
##' @param path to the RcppExports file
##' @export
get_package_details <- function(path){
  package_path <- Sys.glob(file.path(
    path,"src", "RcppExports.cpp"))
  funs<- nc::capture_all_str(
    package_path,
    "\n\\s*// ",
    commentName=".*",
    "\n",
    prototype=list(
      returnType=".*",
      " ",
      funName=".*?",
      "\\(",
      arguments=".*",
      "\\);"),"\n",
    SEXP=".*\n","\\s*BEGIN_RCPP\\s*\n",
    code="(?:.*\n)*?",
    "\\s*END_RCPP")
}

##' @title gets function body
##' @return function.list list with function names and arguments
##' @param package_name to the RcppExports file
##' @export
get_function_body<-function(package_name){
  funs <- get_package_details(package_name) 
  function.list <- funs[,{
    dt <- nc::capture_all_str(
      code,
      "input_parameter< ",
      argument.type=".*?",
      ">::type",
      argument.name="[^(]+")
  }, by=funName]
  return(function.list)
}

##' @title gets prototype calls
##' @return prototypes list with function prototype
##' @param package_name to the RcppExports file
##' @export
get_prototype_calls <-function(package_name){
  funs <- get_package_details(package_name) 
  codes <- funs[,{nc::capture_all_str(code,"::wrap",calls ="(?:.*)")},by=funName]
  prototypes <-funs[,.(funName,prototype,calls=codes$calls)]
  return(prototypes)
}