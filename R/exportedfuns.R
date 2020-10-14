##' @title  deepstate_getRcppExports 
##' @export
deepstate_test<- function(){
  vec<-Sys.glob(file.path("/home/akolla/R/x86_64-pc-linux-gnu-library/3.6/RcppDeepState/extdata/compileAttributes","*"))
  pkg.execlist <- list() 
  pkg.unexlist <- list()
  i = 0
  funs = 0
  for(pkg.i in seq_along(vec)){
    fun.lists <-""
    #print("before read")
    funnamespace = readLines(file.path(vec[[pkg.i]],"NAMESPACE"),warn = FALSE)
    #print("after read")
    namespace.list <- nc::capture_all_str(funnamespace,
                                          status=".*",
                                          "\\(",
                                          fun=".*",
                                          "\\)")
    export_list <- namespace.list[status == "export", fun]
    tests.list<- file.path(vec[[pkg.i]], "inst/testfiles")
    fun.lists <- Sys.glob(paste0(tests.list,"/*"))
    fun.lists <- basename(fun.lists)
    #cat(sprintf("Exported Functions : %s\n ",str(export_list)))
    #cat(sprintf("Function List : %s\n ",str(fun.lists)))
    if(length(intersect(export_list, fun.lists)) > 1){
      i = i + 1
    funs = funs + length(intersect(export_list, fun.lists))
    cat(sprintf(" %d . Package name : %s\n ",i,basename(vec[[pkg.i]])))
    cat(sprintf("Matched functions : %s\n ",list(intersect(export_list, fun.lists))))
    ret.list <- c(intersect(export_list, fun.lists))
    #print(ret.list)
    #fun.list <- file.path(tests.list,ret.list)
    fun.list <- file.path(vec[[pkg.i]],"inst/testfiles",ret.list)
    #print(fun.list)
    exelist <- list()
    unexelist <- list()
    for(fun.i in fun.list){
      harness <-file.path(fun.i,paste0(basename(fun.i),"_DeepState_TestHarness.cpp"))
      obj <- file.path(fun.i,paste0(basename(fun.i),"_DeepState_TestHarness.o"))
      exec <-file.path(fun.i,paste0(basename(fun.i),"_DeepState_TestHarness"))
      if(file.exists(harness) && file.exists(obj) && file.exists(exec)){
        exelist<- c(exelist,basename(fun.i))
      }
      else{
        unexelist<-c(unexelist,basename(fun.i))
      }
    }
    pkg.execlist[[basename(vec[[pkg.i]])]] <-exelist
    pkg.unexlist[[basename(vec[[pkg.i]])]] <-unexelist
    
    }
  }
  print("Done")
  print("Executed package:\n")
  print(pkg.execlist)
  print("Unexecuted package:\n")
  print(pkg.unexlist)
  cat(sprintf("Total number of exported functions :%d\n",funs))
  }