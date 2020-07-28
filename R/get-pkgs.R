Rcpp.LinkingTo.pkgs <- devtools::revdep("Rcpp", "LinkingTo")
dir.create("packages")
download.packages(Rcpp.LinkingTo.pkgs, "packages", type="source")
