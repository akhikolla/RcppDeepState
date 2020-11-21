##' @title  creates testharness for given function in package
##' @param package_name to the RcppExports file
##' @param function_name of the package
##' @export
deepstate_editable_fun<-function(package_name,function_name){
  deepstate_fun_create(package_name,function_name,sep="generation")  
  deepstate_fun_create(package_name,function_name,sep="checks")  
}