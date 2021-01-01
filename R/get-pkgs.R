##' @title  deepstate_datatype_check
##' @param params.list to the package test file
##' @export
deepstate_datatype_check <- function(params.list){
  params.list <- gsub("const","",params.list)
  params.list <-gsub("Rcpp::","",params.list)
  params.list <-gsub(" ","",params.list)
datatypes <- list("NumericVector","NumericMatrix" ,"arma::mat","double",
                  "string","CharacterVector","int","IntegerVector")
for(pkg.i in seq_along(params.list)){
  #print(params.list[[pkg.i]])
  if(is.element(params.list[[pkg.i]], datatypes) =="FALSE"){
    return(0);
  }
  
}
return(1);
}







globalVariables(c("argument.name","funName","argument.type","calls"
                  ,"code","funName",".","error.i","src.file.lines",
                  "heapsum","file.line","arg.name","value",":=",".N","f","fun_name"
                  ,"read.table","new.i.vec","download.file","result","inputs",
                  "rest","status","fun","max_inputs","package_name","pkg.list","testfiles.res"))

globalVariables(c("error.i","error.type","sanitizer","function.i",
                  "src.file.lines","heapsum","file.line","arg.name",
                  "value",".N",":=","prototype","data.table"))

