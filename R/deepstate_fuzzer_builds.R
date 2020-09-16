##' @title  creates afl fuzzer for given functions in package
##' @export
deepstate_afl_make<-function(){ 
  #insts.path <- system.file(package="RcppDeepState")
  insts.path <- "~"
  deepstate.path <- paste0(insts.path,"/.RcppDeepState")
  #dir.create(deepstate.path,showWarnings = FALSE)
  master <- file.path(deepstate.path,"deepstate-master")
  #afl <- file.path(deepstate.path,"AFL-master")
  system(paste0("cd ", deepstate.path, " ; "," wget http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz && tar -xzvf afl-latest.tgz && rm -rf afl-latest.tgz && cd afl-2.52b",";", "make"))
  build_afl <- file.path(master,"build_afl")
  dir.create(build_afl,showWarnings = FALSE)
  system("export AFL_HOME=\"/afl-2.52b\"")
  system(paste0("cd ", build_afl," ; ","CXX=\"afl-clang++\" CC=\"$AFL_HOME/afl-clang\" cmake -DDEEPSTATE_AFL=ON ../"," ; ", "make -j4"))
}

deepstate_HonggFuzz_make <- function(){
  insts.path <- "~"
  deepstate.path <- paste0(insts.path,"/.RcppDeepState")
  system(paste0("cd ", deepstate.path, " ; ","git clone https://github.com/google/honggfuzz && cd honggfuzz && make"))
  master <- file.path(deepstate.path,"deepstate-master")
  build_honggfuzz <- file.path(master,"build_honggfuzz")
  dir.create(build_honggfuzz,showWarnings = FALSE)
  system("export HONGGFUZZ_HOME=\"/honggfuzz\"")
  system(paste0("cd ", build_honggfuzz," ; ","CXX=\"$HONGGFUZZ_HOME/hfuzz_cc/hfuzz-clang++\" CC=\"$HONGGFUZZ_HOME/hfuzz_cc/hfuzz-clang\" cmake -DDEEPSTATE_HONGGFUZZ=ON ../"," ; ", "make"))
  
}

deepstate_Angora_make <- function(){
  insts.path <- "~"
  deepstate.path <- paste0(insts.path,"/.RcppDeepState")
  system(paste0("cd ", deepstate.path, " ; ","git clone https://github.com/AngoraFuzzer/Angora && cd Angora && ./build/build.sh"))
  master <- file.path(deepstate.path,"deepstate-master")
  build_angora <- file.path(master,"build_angora")
  dir.create(build_angora,showWarnings = FALSE)
  system("export PATH=\"/clang+llvm/bin:$PATH\"")
  system("export LD_LIBRARY_PATH=\"/clang+llvm/lib:$LD_LIBRARY_PATH\"")
  system("export ANGORA_HOME=\"/angora\"")
  system(paste0("cd ", build_angora," ; ","CXX=\"$ANGORA_HOME/bin/angora-clang++\" CC=\"$ANGORA_HOME/bin/angora-clang\" cmake -DDEEPSTATE_ANGORA=ON ../"," ; ", "make"))
}

deepstate_Eclipser_make <- function(){
  insts.path <- "~"
  deepstate.path <- paste0(insts.path,"/.RcppDeepState")
  system(paste0("cd ", deepstate.path, " ; ","git clone https://github.com/SoftSec-KAIST/Eclipser && cd Eclipser && make"))
  master <- file.path(deepstate.path,"deepstate-master")
  #build_eclipser <- file.path(master,"build_eclipser")
  system(paste0("export ECLIPSER_HOME=",deepstate.path,"/Eclipser/build"))
}

deepstate_libFuzzer_make <- function(){
  insts.path <- "~"
  deepstate.path <- paste0(insts.path,"/.RcppDeepState")
  master <- file.path(deepstate.path,"deepstate-master")
  build_libfuzzer <- file.path(master,"build_libfuzzer")
  dir.create(build_libfuzzer,showWarnings = FALSE)
  system(paste0("cd ", build_libfuzzer," ; ","CXX=clang++ CC=clang cmake -DDEEPSTATE_LIBFUZZER=ON ../"," ; ", "make -j4"))
}