##' @title  creates afl fuzzer for given functions in package
##' @export
deepstate_afl_make<-function(){ 
  #insts.path <- system.file(package="RcppDeepState")
  insts.path <- "~"
  deepstate.path <- paste0(insts.path,"/.RcppDeepState")
  #dir.create(deepstate.path,showWarnings = FALSE)
  afl.zip <- file.path(deepstate.path,"afl-master.zip")
  master <- file.path(deepstate.path,"deepstate-master")
  afl <- file.path(deepstate.path,"AFL-master")
  system(paste0("wget -O ",afl," https://github.com/google/AFL/archive/master.zip"))
  unzip(afl.zip, exdir=deepstate.path)
  system(paste0("cd ", afl," ;" ,"make"))
  #system(paste0("cd ",  master ,";"))
  build_afl <- file.path(master,"build_afl")
  dir.create(build_afl,showWarnings = FALSE)
  system(paste0("cd ", build_afl," ; ","CXX=\"afl-clang++\" CC=\"$AFL_HOME/afl-clang\" cmake -DDEEPSTATE_AFL=ON ../"," ; ", "make -j4"))
}

deepstate_libFuzzer_make <- function(){
  insts.path <- "~"
  deepstate.path <- paste0(insts.path,"/.RcppDeepState")
  master <- file.path(deepstate.path,"deepstate-master")
  build_libfuzzer <- file.path(master,"build_libfuzzer")
  dir.create(build_libfuzzer,showWarnings = FALSE)
  system(paste0("cd ", build_libfuzzer," ; ","CXX=clang++ CC=clang cmake -DDEEPSTATE_LIBFUZZER=ON ../"," ; ", "make -j4"))
}


deepstate_HonggFuzz_make <- function(){
  insts.path <- "~"
  deepstate.path <- paste0(insts.path,"/.RcppDeepState")
  master <- file.path(deepstate.path,"deepstate-master")
  build_honggfuzz <- file.path(master,"build_honggfuzz")
  dir.create(build_libfuzzer,showWarnings = FALSE)
  system(paste0("cd ", build_honggfuzz," ; ","CXX=hfuzz_cc/hfuzz-clang++ CC=hfuzz_cc/hfuzz-clang cmake -DDEEPSTATE_HONGGFUZZ=ON ../"," ; ", "make -j4"))
  
}

