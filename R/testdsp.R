##' @title deepstate_display
##'
##' @return count.dt list with error messgae
##' 
##' @author Akhila Chowdary Kolla
##' 
##' @param logfile path to the logfile
##' @import data.table
##' @import RcppArmadillo
##' @export

deepstate_user_error_display<-function(logfile){
  count.dt <- ""
  if(length(logfile) > 0){
    display.dt <- nc::capture_all_str(
      logfile,
      inputs="(?:[a-zA-Z ]+values:(?:.*\n)*?)inputends\n+",
      errortrace="(?:.*\n)*?", 
      "==[0-9]+== HEAP SUMMARY:",
      "\n",
      heapsum="(?:.*\n)*?",
      "==[0-9]+== LEAK SUMMARY:",
      "\n",
      leaksum="(?:.*\n)*?",
      "==[0-9]+== ERROR SUMMARY:") 
    
  }
}
