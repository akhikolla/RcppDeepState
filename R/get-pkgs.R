##' @title  deepstate_getRcpppackages
##' @export
deepstate_getRcpppackages <- function(){
packages <- file.path(system.file("extdata",package="RcppDeepState"),"packages")
Rcpp.LinkingTo.pkgs <- devtools::revdep("Rcpp", "LinkingTo")
dir.create(packages)
download.packages(Rcpp.LinkingTo.pkgs, packages, type="source")
}

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
