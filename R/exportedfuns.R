##' @title  deepstate_getRcppExports 
##' @export
deepstate_test<- function(){
  cA.dir <- file.path(system.file("extdata",package="RcppDeepState"),"compileAttributes")
  vec <- Sys.glob(paste0(cA.dir,"/*"))
  for(pkg.i in seq_along(vec)){
    cat(sprintf("\nPackage name : %s\n - ",basename(vec[[pkg.i]])))
    if(pkg.i == 275) 
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
    RcppExports.cpp <- file.path(vec[[pkg.i]], "src/RcppExports.cpp")
    generated <- if(file.exists(RcppExports.cpp)){
      funs <- RcppDeepState::deepstate_get_function_body(vec[[pkg.i]])
      if(!is.null(funs) && length(funs) > 1){
        fun_names <- unique(funs$funName)
        for(function_name.i in fun_names){
          write_to_file <- ""
          functions.rows  <- funs [funs$funName == function_name.i,]
          params <- c(functions.rows$argument.type)
          if( RcppDeepState::deepstate_datatype_check(params) == 1){
            fun.lists <- c(fun.lists,funs$funName)
          }
        }
        print(export_list)
        print("----------------")
        print(fun.lists)
        print(intersect(export_list, fun.lists))
      }
    }
  }
}