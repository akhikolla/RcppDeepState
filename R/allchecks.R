##' @title  analyze the asan and valgrind checks 
##' @param path to the package we are working on 
##' @export
deepstate_allchecks <- function(path){
log_files <- deepstate_list_log_files(path)
for(log.i in log_files){
  if(file.exists(log.i) && length(log.i) > 1 ){
  msg <-  deepstate_displays(log.i)
  if(nrow(msg) >= 1){
    print("valgind checks doesn't detect any issue with the package")
    inst_path <- file.path(path, "inst")
    test_path <- file.path(inst_path,"testfiles")
    #makefile.i <- gsub("_log$",".Makefile",log.i)
    makefile.i <- paste0(dirname(log.i),"/Makefile")
    executable <- gsub("_log$","_DeepState_TestHarness",log.i)
    object <- paste0(executable,".o")
    makefile_lines <- readLines(makefile.i,warn=FALSE)
    makefile_lines <-gsub("clang++","clang++ -fsanitize=address -ggdb -fno-omit-frame-pointer ",makefile_lines,fixed=TRUE)
    makefile_lines <- gsub("valgrind --tool=memcheck --leak-check=yes --track-origins=yes","",makefile_lines)
    makefile_lines <- gsub(log.i,gsub("_log$","_asan_log",log.i),makefile_lines)
    makefile.asan <- gsub(".Makefile","_asan.Makefile",makefile.i)
    asan_log <- gsub(".Makefile","_asan_log",makefile.i)
    file.create(makefile.asan,recursive=TRUE)
    cat(makefile_lines, file=makefile.asan, sep="\n")
    file.remove(object)
    file.remove(executable)
        compile_line <-paste0("rm -f *.o && make -f ",makefile.asan)
        #print(compile_line) 
        system(compile_line)
        asan_result <- deepstate_user_asan_error_display(asan_log)
        if(asan_result$count == 0) print("no error detected using asan")
        else {
          print("detected error using asan")
          print(asan_result)}
    }
  else{
       print(result)
      print("found a bug in package using valgrind!!")
    }
  }
  else {print("valgind checks doesn't detect any issue with the package")}
}
}
