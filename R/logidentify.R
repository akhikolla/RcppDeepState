##' @title deepstate_logcheck
##' 
##' @author Akhila Chowdary Kolla
##' @export
##' 
deepstate_logcheck <- function(){
zip.path <- "/home/akhila/Documents/compileAttributescheck/"
tgz.vec <- Sys.glob("/home/akhila/Documents/compileAttributescheck/*")
for(pkg.i in seq_along(tgz.vec)){
  pkg.name <- tgz.vec[[pkg.i]]
  RcppExports.cpp <- file.path(pkg.name, "src/RcppExports.cpp")
 if(file.exists(RcppExports.cpp)){
  log_files <- deepstate_list_log_files(pkg.name)
  print(pkg.name)
  for(log.i in log_files){
    if(file.exists(log.i)){
      print(log.i)
      result <- deepstate_display(log.i)
      if(!is.null(nrow(result)) || nrow(result) != 0){
        #print(result)
        log.path <- file.path(dirname(dirname(pkg.name)),"errorlogs",basename(pkg.name))
        dir.create(log.path,showWarnings=FALSE)
        file.copy(log.i,log.path)
      }
      else{
        print("no error")
      }
    }
    else
    {print("log file doesn't exist")}
  }
 }
}
}
    
  
  
  
