##' @title deepstate_get_mismatched_datatypes
##' @param params.list to the package test file
##' @export
deepstate_get_mismatched_datatypes <- function(params.list){
  params.list <- gsub("const","",params.list)
  params.list <-gsub("Rcpp::","",params.list)
  params.list <-gsub(" ","",params.list)
  datatypes <- list("NumericVector","NumericMatrix" ,"arma::mat","double",
                  "string","CharacterVector","int","IntegerVector")
  mismatched_datatypes <- list()
  matched <- params.list %in% datatypes
  if (!all(matched)){
    mismatched_datatypes <- params.list[!matched]
  }

  mismatched_datatypes

}




globalVariables(c("argument.name","funName","argument.type","calls"
                  ,"code","funName",".","error.i","src.file.lines",
                  "heapsum","file.line","arg.name","value",":=",".N","f","fun_name"
                  ,"read.table","new.i.vec","download.file","result","inputs",
                  "rest","status","fun","max_inputs","package_name","pkg.list","testfiles.res"))

globalVariables(c("error.i","error.type","sanitizer","function.i",
                  "src.file.lines","heapsum","file.line","arg.name",
                  "value",".N",":=","prototype","data.table"))

