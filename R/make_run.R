##' @title  creates testharness for given functions in package
##' @export
deepstate_make_run<-function(){ 
  #insts.path <- system.file(package="RcppDeepState")
  insts.path <- normalizePath("~", mustWork=TRUE)
  deepstate.path <- paste0(insts.path,"/.RcppDeepState")
  dir.create(deepstate.path,showWarnings = FALSE)
  deepstate.zip <- file.path(deepstate.path, "deepstate-master.zip")
  system(paste0("wget -O ",deepstate.zip," https://github.com/trailofbits/deepstate/archive/master.zip"))
  #download.file("https://github.com/trailofbits/deepstate/archive/master.zip", deepstate.zip)
  #download.file("https://github.com/trailofbits/deepstate/archive/master.zip",deepstate.zip,"auto")
  unzip(deepstate.zip, exdir=deepstate.path)
  #deepstate.path <- file.path(insts.path,"deepstate")
  #system(paste0("cd ",insts.path, " ; ", "git clone https://github.com/trailofbits/deepstate.git"))
  master <- file.path(deepstate.path,"deepstate-master")
  deepstate.build <- paste0(master,"/build")
  #system(paste0("mkdir ", deepstate.build ," ; "))
  dir.create(deepstate.build,showWarnings = FALSE)
  system(paste0("cd ", deepstate.build," ; ","cmake ../", " ; ","make"))
  #system("sudo make install")
}