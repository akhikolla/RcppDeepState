##' @title deepstate_displays
##' 
##' @author Akhila Chowdary Kolla
##' @param logfile path to the logfile
##' @export
deepstate_displays <- function(logfile){
  messages.raw <- nc::capture_all_str(
    logfile,
    "input starts\n",
    inputs="(?:.*\n)+?",
    "input ends\n",
    rest="(?:.+\n)+")
  messages.raw[, message.i := 1:.N]
  
  prefix <- function(after){
    list("==[0-9]+==", after)
  }
  trace.pattern <- nc::quantifier(
    prefix("    "),
    "(?:at|by).*\n",
    "+")
  
  messages.parsed <- messages.raw[, {
    values.dt <- nc::capture_all_str(
      inputs,
      variable=".*?",
      " ",
      nc::field("values", ": ", "(?:.*\n)*"))
  
    problems.dt <- nc::capture_all_str(
      rest,
      prefix(" "),
      problem="[^ \n].*",
      "\n",
      problem.trace=trace.pattern,
      prefix("  "),
      address=".*",
      "\n",
      address.trace=trace.pattern)
    data.table::data.table(
      arguments=list(values.dt),
      problems=list(problems.dt))
  }, by=.(message.i)]
  
  str(messages.parsed)
  for(message.i in 1:nrow(messages.parsed)){
    cat(sprintf("\nmessage=%d\n", message.i))
    str(messages.parsed[["arguments"]][[message.i]])
    print(tibble::tibble(messages.parsed[["problems"]][[message.i]]))
  }
}