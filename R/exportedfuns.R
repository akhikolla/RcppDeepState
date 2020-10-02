##' @title  deepstate_getRcppExports 
##' @export
deepstate_test<- function(){
  cA.dir <- file.path(system.file("extdata",package="RcppDeepState"),"compileAttributes")
  vec <- Sys.glob(paste0(cA.dir,"/*"))
  for(pkg.i in seq_along(vec)){
    if(pkg.i == 276) 
    {break}
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
    cat(sprintf(" %d . Package name : %s\n ",pkg.i,basename(vec[[pkg.i]])))
    cat(sprintf("Matched functions : %s\n ",intersect(export_list, fun.lists)))
    }
      }
    }