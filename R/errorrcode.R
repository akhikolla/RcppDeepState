##' @title deepstate_user_error_display
##'
##' @return count.dt list with error messgae,inputs which caused the error,
##'   corresponding line and datavariable name
##' 
##' @author Akhila Chowdary Kolla
##' 
##' @param logfile path to the logfile
##' @import data.table
##' @import RcppArmadillo
##' @export

deepstate_user_error_display<-function(logfile){
  error.dt <- nc::capture_all_str(
    logfile,
    arg.name=".*?",
    " values:",
    value=".*",
    "\n",
    errortrace="(?:.*\n)*?", 
    "==[0-9]+== HEAP SUMMARY:",
    "\n",
    heapsum="(?:.*\n)*?",
    "==[0-9]+== LEAK SUMMARY:",
    "\n",
    leaksum="(?:.*\n)*?",
    "==[0-9]+== ERROR SUMMARY:")
  
  files.list<-nc::capture_all_str(logfile,"Command: ./",
                                  file.name=".*",
                                  "_DeepState_TestHarness")
  error.dt[, error.i := 1:.N]
  trace <- gsub("==[0-9]+== Warning:.*?\\n","",error.dt$errortrace)
  trace <- paste0(trace,error.dt$heapsum,error.dt$leaksum)
  print(trace)
  error.dt[, src.file.lines := {
    file.line.dt <- nc::capture_all_str(
      trace,
      file.line="[^()]+?:[0-9]+")
    file.line.dt[grepl(paste0(files.list$file.name,".cpp"), file.line),paste(file.line, collapse="\n")]
  }, by=error.i]
  
  error.msg <- nc::capture_first_vec(trace,
                                     msg=".*")
  #error.msg <- nc::capture_first_vec(error.dt$errortrace,"\n",
  #                                  err.msg=".*")
  count.dt <- error.dt[, .(
    count=.N
  ), by=.(arg.name,value,src.file.lines,error.message=gsub("==[0-9]+==","",error.msg$msg))]
  
  return(count.dt)
}

globalVariables(c("error.i","error.type","sanitizer","function.i","src.file.lines","heapsum","file.line","arg.name","value",".N",":=","prototype"))
