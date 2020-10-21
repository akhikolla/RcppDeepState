##' @title  deepstate_logtest
##' @param log file to parse
##' @import nc
##' @export
deepstate_logtest <- function(log){
     issue.dt.list <- list()
    if(length(grep("<file>src/",readLines(log)))){
       trace <- list("\\s*<frame>\n\\s*","<ip>",".*","</ip>\n\\s*",
                     "<obj>",".*","</obj>\n\\s*",
                     "<fn>",".*","</fn>\n\\s*",
                     "<dir>",path=".*","</dir>\n\\s*",
                     "<file>",file="src.*","</file>\n\\s*",
                     "<line>",line=".*","</line>\n\\s*","</frame>\n\\s*")
     }else{
       trace <- list("\\s*<frame>\n\\s*","<ip>",".*","</ip>\n\\s*",
                     "<obj>",".*","</obj>\n\\s*",
                     "<fn>",".*","</fn>\n\\s*",
                     "<dir>",path=".*.src","</dir>\n\\s*",
                     "<file>",file=".*","</file>\n\\s*",
                     "<line>",line=".*","</line>\n\\s*","</frame>\n\\s*")
     }

  address.trace <- list("<auxwhat>",address=".*","</auxwhat>\n\\s*",
                        "<stack>\n\\s*",stack="(?:.+\n)+")
  traces <- nc::capture_all_str(log,"<error>\n\\s{2}",
                                trace="(?:.+\n)+",
                                "</error>\n")

  if(nrow(traces)){
    for(i in 1:length(traces$trace)) {
      error.row <- traces$trace[i]
      if(any(grep("<xwhat>",error.row,fixed = TRUE))){
        kind <- nc::capture_all_str(error.row,"<kind>",kinds=".*","</kind>\n\\s*","<xwhat>\n\\s*",
                                    "<text>",msg=".*","</text>\n")
      }else{
        kind <- nc::capture_all_str(error.row,"<kind>",kinds=".*","</kind>\n\\s*",
                                    msg=".*","\n")
      }
      log.stack.traces <- nc::capture_all_str(error.row,"<stack>\n\\s",st="(?:.+\n)+",
                                              "\\s*</stack>")
      
      stack.rows <- log.stack.traces$st
      #print(stack.rows)
      #stack.msg <- nc::capture_all_str(stack.rows,trace)
      #print(stack.msg)
      add.trace="NA"
      address="NA"
      if(length(stack.rows)){
        if(any(grep("<auxwhat>",error.row,fixed = TRUE))){
          stack.msg <- nc::capture_first_vec(stack.rows,trace)
          #print(stack.msg)
          #print(nrow(stack))
          if(length(stack.msg)){
            #print(stack.msg$file)
            err.trace=paste0(stack.msg$file," : ",stack.msg$line)
          }else{err.trace="NA"}
          address.trace <- nc::capture_first_vec(error.row,"<auxwhat>",address=".*","</auxwhat>\n")
          address=address.trace$address
          if(nrow(address.trace)){
            address.msg <- nc::capture_first_vec(error.row,"<auxwhat>",address=".*","</auxwhat>\n\\s*",
                                                 "<stack>\n\\s*",stack="(?:.*\n)+","\\s*</stack>")
          }
          if(length(address.msg$stack) > 0){
          add.stack.msg<-nc::capture_first_vec(address.msg$stack,trace)
          if(nrow(add.stack.msg)){
            add.trace=paste0(add.stack.msg$file," : ",add.stack.msg$line)
          }
          }
        }else{
          address="No address trace found"
          stack.msg<- nc::capture_first_vec(stack.rows,trace)
          if(nrow(stack.msg)){
          err.trace<-paste0(stack.msg$file," : ",stack.msg$line)
          }
        }
      }
      issue.dt.list[[i]] <- data.table(kind=kind$kinds,
                                       msg=gsub("<what>|</what>","",kind$msg), 
                                       errortrace=err.trace,
                                       address=address,
                                       trace=add.trace)
      
      
    } 
    issue.dt.list<-unique(issue.dt.list, incomparables = FALSE)
    issue.dt.list <- do.call(rbind,issue.dt.list)
  }else{  
    log_text <- paste0(log,"_text")
    issue.dt.list<-nc::capture_all_str(log_text,"ERROR: ",err.msg=".*")
    if(nrow(issue.dt.list)){
      return(issue.dt.list)
    }
    else{
      issue.dt.list <- list()
    }
  }
  #return()
  #print(class(issue.dt.list))
  return(issue.dt.list)
}
