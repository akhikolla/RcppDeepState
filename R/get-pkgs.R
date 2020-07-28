##' @title getRcppLinkpackages
##' @author Akhila Chowdary Kolla
##' 
getRcppLinkpackages<-function(){
Rcpp.LinkingTo.pkgs <- devtools::revdep("Rcpp", "LinkingTo")
dir.create("packages")
download.packages(Rcpp.LinkingTo.pkgs, "packages", type="source")
}