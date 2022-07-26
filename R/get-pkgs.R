##' @title deepstate_get_unsupported_datatypes
##' @param params.list to the package test file
##' @export
deepstate_get_unsupported_datatypes <- function(params.list){
  params.list <- gsub("const","",params.list)
  params.list <- gsub("Rcpp::","",params.list)
  params.list <- gsub("arma::","",params.list)
  params.list <- gsub("std::","",params.list)
  params.list <-gsub(" ","",params.list)

  datatypes <- list("NumericVector","NumericMatrix" ,"mat", "double",
                  "string","CharacterVector","int","IntegerVector")

  matched <- params.list %in% datatypes
  unsupported_datatypes <- params.list[!matched]

}




globalVariables(c("argument.name","funName","argument.type","calls"
                  ,"code","funName",".","error.i","src.file.lines",
                  "heapsum","file.line","arg.name","value",":=",".N","f","fun_name"
                  ,"read.table","new.i.vec","download.file","result","inputs",
                  "rest","status","fun","max_inputs","package_name","pkg.list","testfiles.res"))

globalVariables(c("error.i","error.type","sanitizer","function.i",
                  "src.file.lines","heapsum","file.line","arg.name",
                  "value",".N",":=","prototype","data.table"))

