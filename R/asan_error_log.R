##' @title  analyze the binary file 
##' @param path to test
##' @return returns a list of all the param values of log files
##' @export
deepstate_user_asan_error_display <- function(path){
  error.dt <- nc::capture_all_str(
    path,
    "==[0-9]+==ERROR: ",
    sanitizer=".*?",
    ": ",
    error.type=".*?",
    " ",
    error.details=".*",
    "\n",
    trace="(?:.*\n)*?",
    "SUMMARY")
  error.dt[, error.i := 1:.N]
  error.dt[, src.file.lines := {
    file.line.dt <- nc::capture_all_str(
      trace,
      file.line="[^ ]+?:[0-9]+")
    file.line.dt[grepl("/src/", file.line), paste(file.line, collapse="\n")]
  }, by=error.i]
  count.dt <- error.dt[, .(
    count=.N
  ), by=.(sanitizer, error.type, src.file.lines)]
  
}