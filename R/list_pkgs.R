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
    generated <- if(file.exists(RcppExports.cpp)){
      result <-  deepstate_pkg_create(file.path(zip.path,pkg.name))
      print(result)
      if(result == "success"){
        #devtools::install(file.path(paste0(zip.path,pkg.name)),upgrade="always")
        deepstate_harness_compile_run(file.path(zip.path,pkg.name))  
        deepstate_harness_analyze_one(file.path(zip.path,pkg.name))
        #deepstate_allchecks(file.path(zip.path,pkg.name))
      }
      else{
        file.copy(file.path(zip.path,pkg.name),untestable_pkgs,overwrite = TRUE, 
                  recursive = TRUE, 
                  copy.mode = TRUE)
        unlink(file.path(zip.path,pkg.name), recursive = TRUE)
        print("Package cannot be tested using RcppDeepState!!")
      }
      
    } 
  }
}