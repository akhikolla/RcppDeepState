##' @title gets package details
##' @return function list with function names and arguments
##' @param path to the RcppExports file
##' @export
deepstate_get_package_details <- function(path){
  funs <- ""
  package_path <- Sys.glob(file.path(
    path,"src", "RcppExports.cpp"))
  if(length(package_path) > 0){
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
}

##' @title gets function body
##' @return function.list list with function names and arguments
##' @param package_name to the RcppExports file
##' @export
deepstate_get_function_body<-function(package_name){
  funs <- deepstate_get_package_details(package_name) 
  function.list <-""
  if(nrow(funs) > 0){
    function.list <- funs[,{
      dt <- nc::capture_all_str(
        code,
        "input_parameter< ",
        argument.type=".*?",
        ">::type",
        argument.name="[^(]+")
    }, by=funName]
  }
  return(function.list)
}

##' @title gets prototype calls
##' @return prototypes list with function prototype
##' @param package_name to the RcppExports file
##' @export
deepstate_get_prototype_calls <-function(package_name){
  funs <- deepstate_get_package_details(package_name) 
  codes <- funs[,{nc::capture_all_str(code,"::wrap",calls ="(?:.*)")},by=funName]
  prototypes <-funs[,.(funName,prototype,calls=codes$calls)]
  return(prototypes)
}