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
  
  files.list<-nc::capture_all_str(logfile,"Command: ./",
                                  file.name=".*",
                                  "_DeepState_TestHarness")
  Testharness <- paste0("DeepState_Test_",basename(gsub("/inst/testfiles/.*","",logfile)),
                        "_deepstate_test_",files.list$file.name,"_test")
  
  prefix <- function(after){
    list("==[0-9]+==", after)
  }
  trace.pattern <- nc::capture_all_str(
    ress,
    val="(?:at|by).*\n"
    )
  trace.pattern <- nc::capture_all_str(
    ress,
    val="[^(?:(?:at|by).*\n)+]"
  )
  code.line <- function(pattern){
    file.line.dt <- nc::capture_all_str(
      pattern,
      "==[0-9]+==","\\s*",
      trace=".*\n",
      ".*",
      Testharness)
    return(file.line.dt$trace)
    }
  
  rest <- gsub("==[0-9]+== Warning:.*?\\n","",messages.raw$rest)
#print(rest)
  if( length(rest) >= 1){ 
    #print("in if")
    messages.parsed <- messages.raw[, {
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
    problems.dt$problem.trace = code.line(problems.dt$problem.trace)
    problems.dt$address.trace = code.line(problems.dt$address.trace)
    data.table::data.table(
      problems=list(problems.dt))
  }, by=.(message.i)]
    str(messages.parsed)
    for(message.i in 1:nrow(messages.parsed)){
      #cat(sprintf("\nmessage=%d\n", message.i))
      #cat(sprintf("\ninputs=%s\n", messages.raw$inputs))
      #str(messages.parsed[["arguments"]][[message.i]])
      print(tibble::tibble(messages.parsed[["problems"]][[message.i]]))
    }
    
  }
  
  else{
    file.line.dt <- nc::capture_all_str(
      rest,
      "==[0-9]+==",
      val="(?:(?!at|by).)*\n",
      "==[0-9]+== ","\\s*",
      data=".*\n",
      ".*",
      Testharness)
    print(file.line.dt)   
  }
}