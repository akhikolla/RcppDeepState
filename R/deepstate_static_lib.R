##' @title  creates static library
##' @export
deepstate_create_static_lib <- function(){
  inst_path <- system.file(package="RcppDeepState")
  print(inst_path)
  deepstate_path <- file.path(inst_path,"include")
  compile_line <- "gcc -fpic  -g -O2 "
  DeepState.c.o <- paste0(compile_line,file.path(deepstate_path,"DeepState.c")," -o ",file.path(deepstate_path,"DeepState.o")," -c ")
  Log.c.o <- paste0(compile_line,file.path(deepstate_path,"Log.c")," -o ",file.path(deepstate_path,"Log.o")," -c ")
  Option.c.o <- paste0(compile_line,file.path(deepstate_path,"Option.c")," -o ",file.path(deepstate_path,"Option.o")," -c ")
  Stream.c.o <- paste0(compile_line,file.path(deepstate_path,"Stream.c")," -o ",file.path(deepstate_path,"Stream.o")," -c ")
  objects <- paste0(file.path(deepstate_path,"DeepState.o")," ",file.path(deepstate_path,"Log.o")," ",file.path(deepstate_path,"Option.o")," ",file.path(deepstate_path,"Stream.o"))
  system(DeepState.c.o)
  system(Log.c.o)
  system(Option.c.o)
  system(Stream.c.o)
  system(paste0("ar qc libdeepstate.a ",objects))
  system(paste0("cp libdeepstate.a ",file.path(inst_path,"extdata"))) 
  system("rm libdeepstate.a")
  system(paste0("rm ",objects))
}