##' @title  creates afl fuzzer for given functions in package
##' @export
deepstate_afl_make<-function(){ 
  #insts.path <- system.file(package="RcppDeepState")
  insts.path <- "~"
  deepstate.path <- paste0(insts.path,"/.RcppDeepState")
  dir.create(deepstate.path,showWarnings = FALSE)
  afl.zip <- file.path(deepstate.path,"afl-master.zip")
  master <- file.path(deepstate.path,"deepstate-master")
  afl <- file.path(deepstate.path,"AFL-master")
  system(paste0("wget -O ",deepstate.afl," https://github.com/google/AFL/archive/master.zip"))
  unzip(deepstate.afl.zip, exdir=deepstate.path)
  system(paste0("cd ", afl," ;" ,"make"))
  #system(paste0("cd ",  master ,";"))
  build_afl <- file.path(master,"build_afl")
  dir.create(build_afl,showWarnings = FALSE)
  system(paste0("cd ", build_afl," ; ","CXX=\"afl-clang++\" CC=\"$AFL_HOME/afl-clang\" cmake -DDEEPSTATE_AFL=ON ../"," ; ", "make -j4"))
  }