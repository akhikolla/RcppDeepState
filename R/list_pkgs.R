##' @title  deepstate_getRcppExports 
##' @export
deepstate_getRcppExports <- function(){
  packages <- file.path(system.file("extdata",package="RcppDeepState"),"packages")
  cA.dir <- file.path(system.file("extdata",package="RcppDeepState"),"compileAttributes")
  dir.create(cA.dir, showWarnings=FALSE)
  root.path <- system.file("extdata",package="RcppDeepState")
  zip.path <- cA.dir
  tgz.vec <- Sys.glob(paste0(packages,"/*.tar.gz"))
  untestable_pkgs <- file.path(root.path,"untestable_pkgscheck")
  folder <- zip.path
  for(pkg.i in seq_along(tgz.vec)){
    pkg.tar.gz <- tgz.vec[[pkg.i]]
    cat(sprintf("%4d - %s\n", pkg.i, pkg.tar.gz))
    if(!dir.exists(untestable_pkgs)){
      dir.create(untestable_pkgs)
    }
    pkg.name <- sub("_.*", "", basename(pkg.tar.gz))
    print(pkg.name)
    untar(pkg.tar.gz,exdir=folder)
    unlink(pkg.tar.gz)
    RcppExports.cpp <- file.path(zip.path,pkg.name, "src/RcppExports.cpp")
    if(file.exists(RcppExports.cpp)){
      RcppDeepState::deepstate_harness_compile_run(file.path(zip.path,pkg.name))
      result = RcppDeepState::deepstate_harness_analyze_pkg(file.path(zip.path,pkg.name))
      print(result$logtable)
     }else{
        file.copy(file.path(zip.path,pkg.name),untestable_pkgs,overwrite = TRUE, 
                  recursive = TRUE, 
                  copy.mode = TRUE)
        unlink(file.path(zip.path,pkg.name), recursive = TRUE)
        print("Package cannot be tested using RcppDeepState!!")
      }
  }
}


