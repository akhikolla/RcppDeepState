##' @title Deepstate Static library
##' @description Creates a deepstate static library for the user in the ~/.RcppDeepState directory.
##' @importFrom utils unzip
##' @export
deepstate_make_run<-function(){ 
  insts.path <- normalizePath("~", mustWork=TRUE)
  deepstate.path <- paste0(insts.path,"/.RcppDeepState")
  dir.create(deepstate.path,showWarnings = FALSE)
  deepstate.zip <- file.path(deepstate.path, "deepstate.zip")
  system(paste0("wget -O ",deepstate.zip," https://github.com/trailofbits/deepstate/archive/master.zip"))
  unzip(deepstate.zip, exdir=deepstate.path)
  master <- file.path(deepstate.path,"deepstate-master")
  deepstate.build <- paste0(master,"/build")
  dir.create(deepstate.build,showWarnings = FALSE)
  system(paste0("cd ", deepstate.build," ; ","cmake ../", " ; ","make"))
}