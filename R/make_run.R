##' @title  creates testharness for given functions in package
##' @export
make_run<-function(){ 
  insts.path <- system.file(package="RcppDeepState")
  deepstate.path <- file.path(insts.path,"deepstate")
  system(paste0("cd ",insts.path, " ; ", "git clone https://github.com/trailofbits/deepstate.git"))
  deepstate.build <- paste0(insts.path,"/deepstate/build")
  system(paste0("mkdir ", deepstate.build ," ; "))
  system(paste0("cd ", deepstate.build," ; ","cmake ../", " ; ","make"))
  system("sudo make install")
}