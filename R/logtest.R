##' @title  deepstate_logtest
##' @param log file to parse
##' @import nc
##' @export
deepstate_logtest <- function(log){
trace <- list("<frame>\n\\s*","<ip>",".*","</ip>\n\\s*",
              "<obj>",".*","</obj>\n\\s*",
              "<fn>",".*","</fn>\n\\s*",
              "<dir>",".*","</dir>\n\\s*",
              "<file>",file="src.*","</file>\n\\s*",
              "<line>",line=".*","</line>\n\\s*","</frame>\n")


address.trace <- list("<auxwhat>",address=".*","</auxwhat>\n\\s*",
                      "<stack>\n\\s*",stack="(?:.+\n)+")


traces <- nc::capture_all_str(log,"<error>\n\\s{2}",
                              trace="(?:.+\n)+",
                              "</error>\n")
issue.dt.list <- list()
if(nrow(traces)){
  for(i in 1:length(traces$trace)) {
    error.row <- traces$trace[i]
    #print(i)
    if(any(grep("<xwhat>",error.row,fixed = TRUE))){
      kind <- nc::capture_all_str(error.row,"<kind>",kinds=".*","</kind>\n\\s*","<xwhat>\n\\s*",
                                  "<text>",msg=".*","</text>\n")
    }
    else{
      kind <- nc::capture_all_str(error.row,"<kind>",kinds=".*","</kind>\n\\s*",
                                  msg=".*","\n")
    }
    #print(kind)
    log.stack.traces <- nc::capture_all_str(error.row,"<stack>\n\\s",st="(?:.+\n)+",
                                            "\\s*</stack>")
    stack.rows <- log.stack.traces$st
    
    if(length(stack.rows)){
      if(any(grep("<auxwhat>",stack.rows,fixed = TRUE))){
        stack.msg <- nc::capture_first_vec(stack.rows,trace)
        err.trace=paste0(stack.msg$file," : ",stack.msg$line)
        address.msg <- nc::capture_all_str(stack.rows,address.trace)
        address=address.msg$address
        stack.msg=nc::capture_all_str(address.msg$stack,trace)
        add.trace=paste0(stack.msg$file," : ",stack.msg$line)
      }else{
        address="No address trace found"
        add.trace="NA"
        err.trace<- nc::capture_all_str(stack.rows,trace)
        err.trace=paste0(stack.msg$file," : ",stack.msg$line)
      }
    }
    issue.dt.list[[i]] <- data.table(kind=kind$kinds,
                                     msg=gsub("<what>|</what>","",kind$msg), 
                                     errortrace=err.trace,
                                     address=address,
                                     trace=add.trace)
    
    
  }  
  print(issue.dt.list)
}else{  
log_text <- paste0(log,"_text")
crashes<-nc::capture_all_str(log_text,"ERROR: ",err.msg=".*")
if(nrow(crashes)){
print(crashes)
}else{print("no errors found")}
}
}