##' @title deepstate_display
##'
##' @return count.dt list with error messgae
##' 
##' @author Akhila Chowdary Kolla
##' 
##' @param logfile path to the logfile
##' @export

deepstate_display<-function(logfile){
  count.dt <- ""
  package_name <- 
  if(length(logfile) > 0){
    display.dt <- nc::capture_all_str(
      logfile,
      inputs="(?:[a-zA-Z ]+values:(?:.*\n)*?)input ends\n+",
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
    Testharness <- paste0("DeepState_Test_",basename(gsub("/inst/testfiles/.*","",logfile)),
                          "_deepstate_test_",files.list$file.name,"_test")
trace <- gsub("==[0-9]+== Warning:.*?\\n","",display.dt$errortrace)
trace <- paste0(trace,display.dt$heapsum,display.dt$leaksum)
display.dt[, trace.i := 1:.N]
if(length(trace) >= 1){
 
for(trace.i in seq_along(trace)){
  log.result<-display.dt[,{
    file.line.dt <- nc::capture_all_str(
    trace[[trace.i]],
    "==[0-9]+==",
    error="(?:(?!at|by).)*\n",
    "==[0-9]+==","\\s*",
    trace=".*\n",
    ".*",
    Testharness)
  },by=inputs]
} 
count.dt <- display.dt[,.(log.result)]
print(count.dt)
}
  return(count.dt)
}

}
