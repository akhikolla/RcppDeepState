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
str(messages.raw)
messages.raw[, message.i := 1:.N]
## using tibble for the compact print method.
tibble::tibble(messages.raw)

prefix <- function(after){
  list("==[0-9]+==", after)
}
trace.pattern <- nc::quantifier(
  prefix("    "),
  "(?:at|by).*\n",
  "+")
tibble::tibble(nc::capture_all_str(
  messages.raw[2, rest],
  prefix(" "),
  problem="[^ \n].*",
  "\n",
  problem.trace=trace.pattern,
  prefix("  "),
  address=".*",
  "\n",
  address.trace=trace.pattern))

values.dt <- nc::capture_all_str(
  messages.raw[2, inputs],
  variable=".*?",
  " ",
  nc::field("values", ": ", ".*"))
tibble::tibble(values.dt)
scan(text=values.dt[1, values], quiet=TRUE)

arg.list <- list()
for(arg.i in 1:nrow(values.dt)){
  arg.row <- values.dt[arg.i]
  v <- arg.row[["variable"]]
  ## Q: how are you going to read values (line of code below) for
  ## types other than NumericVector? 
  arg.list[[v]] <- scan(
    text=arg.row[["values"]], quiet=TRUE)
}

messages.parsed <- messages.raw[, {
  values.dt <- nc::capture_all_str(
    inputs,
    variable=".*?",
    " ",
    nc::field("values", ": ", ".*"))
  arg.list <- list()
  for(arg.i in 1:nrow(values.dt)){
    arg.row <- values.dt[arg.i]
    v <- arg.row[["variable"]]
    ## Q: how are you going to read values (line of code below) for
    ## types other than NumericVector? 
    arg.list[[v]] <- scan(
      text=arg.row[["values"]], quiet=TRUE)
  }
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
    arguments=list(arg.list),
    problems=list(problems.dt))
}, by=.(message.i)]

str(messages.parsed)
for(message.i in 1:nrow(messages.parsed)){
  cat(sprintf("\nmessage=%d\n", message.i))
  str(messages.parsed[["arguments"]][[message.i]])
  print(tibble::tibble(messages.parsed[["problems"]][[message.i]]))
}
return(messages.parsed)
}