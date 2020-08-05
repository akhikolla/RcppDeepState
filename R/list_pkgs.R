##' @title  deepstate_getRcppExports 
##' @export
deepstate_getRcppExports <- function(){
cA.dir <- "/home/akhila/Documents/compileAttributes"
dir.create(cA.dir, showWarnings=FALSE)
root.path <- "/home/akhila/Documents"
zip.path <- "/home/akhila/Documents/compileAttributes/"
tgz.vec <- Sys.glob("/home/akhila/Documents/packages/*.tar.gz")
for(pkg.i in seq_along(tgz.vec)){
  pkg.tar.gz <- tgz.vec[[pkg.i]]
  cat(sprintf("%4d - %s\n", pkg.i, pkg.tar.gz))
  untestable_pkgs <- file.path(root.path,"untestable_pkgs")
  folder <- paste0(zip.path)
  if(!dir.exists(untestable_pkgs)){
    dir.create(untestable_pkgs)
  }
  pkg.name <- sub("_.*", "", basename(pkg.tar.gz))
  untar(pkg.tar.gz,exdir=folder)
  RcppExports.cpp <- file.path(paste0(zip.path,pkg.name), "src/RcppExports.cpp")
  generated <- if(file.exists(RcppExports.cpp)){
    result <- deepstate_pkg_create(file.path(paste0(zip.path,pkg.name)))
    print(result)
    if(result == 1){
    #devtools::install(file.path(paste0(zip.path,pkg.name)),upgrade="always")
    deepstate_harness_compile_run(file.path(paste0(zip.path,pkg.name)))  
    deepstate_allchecks(file.path(paste0(zip.path,pkg.name)))
    }
    else{
    file.copy(file.path(paste0(zip.path,pkg.name)),untestable_pkgs,overwrite = TRUE, 
              recursive = TRUE, 
              copy.mode = TRUE)
    unlink(file.path(paste0(zip.path,pkg.name)), recursive = TRUE)
    print("Package cannot be tested using RcppDeepState!!")
  }
  
  } 
}
}