##' @title getRcppExports
##' @author Akhila Chowdary Kolla
##' 
getRcppExports<-function(){
cA.dir <- "/home/akhila/Documents/compileAttributes"
dir.create(cA.dir, showWarnings=FALSE)
tgz.vec <- Sys.glob("/home/akhila/Documents/pac/*.tar.gz")
for(pkg.i in seq_along(tgz.vec)){
  pkg.tar.gz <- tgz.vec[[pkg.i]]
  cat(sprintf("%4d / %4d %s\n", pkg.i, length(tgz.vec), pkg.tar.gz))
  pkg.name <- sub("_.*", "", basename(pkg.tar.gz))
  RcppExports.cpp <- file.path(pkg.name, "src/RcppExports.cpp")
  ##unzip(pkg.tar.gz,exdir="/home/akhila/Documents/pac/dir")
  ## unlink(RcppExports.cpp)
  ## Rcpp::compileAttributes(pkg.name)
  generated <- if(file.exists(RcppExports.cpp)){
    readLines(RcppExports.cpp)
    print(readLines(RcppExports.cpp))
  }else{
    character()
  }
  unlink(pkg.name, recursive=TRUE)
  if(length(generated)){
    dir.create(dirname(RcppExports.cpp), recursive=TRUE)
    writeLines(generated, RcppExports.cpp)
  }
}
}