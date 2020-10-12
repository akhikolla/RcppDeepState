##' @title  deepstate_logtest
##' @param log file to parse
##' @import nc
##' @export
deepstate_logtest <- function(log){
     issue.dt.list <- list()
    trace <- list("<frame>\n\\s*","<ip>",".*","</ip>\n\\s*",
                "<obj>",".*","</obj>\n\\s*",
                "<fn>",".*","</fn>\n\\s*",
                "<dir>",path=".*.src","</dir>\n\\s*",
                "<file>",file=".*","</file>\n\\s*",
                "<line>",line=".*","</line>\n\\s*","</frame>\n",nomatch.error=FALSE)
    
  address.trace <- list("<auxwhat>",address=".*","</auxwhat>\n\\s*",
                        "<stack>\n\\s*",stack="(?:.+\n)+")
  
  traces <- nc::capture_all_str(log,"<error>\n\\s{2}",
                                trace="(?:.+\n)+",
                                "</error>\n")

  if(nrow(traces)){
    for(i in 1:length(traces$trace)) {
      error.row <- traces$trace[i]
      #print(i)
      if(any(grep("<xwhat>",error.row,fixed = TRUE))){
        kind <- nc::capture_all_str(error.row,"<kind>",kinds=".*","</kind>\n\\s*","<xwhat>\n\\s*",
                                    "<text>",msg=".*","</text>\n")
      }else{
        kind <- nc::capture_all_str(error.row,"<kind>",kinds=".*","</kind>\n\\s*",
                                    msg=".*","\n")
      }
      #print(kind)
      log.stack.traces <- nc::capture_all_str(error.row,"<stack>\n\\s",st="(?:.+\n)+",
                                              "\\s*</stack>")
      stack.rows <- log.stack.traces$st
      add.trace="NA"
      address="NA"
      #print(stack.rows)
      if(length(stack.rows)){
        if(any(grep("<auxwhat>",error.row,fixed = TRUE))){
          #print("in auxwhat")
          stack.msg <- nc::capture_all_str(stack.rows,"<frame>\n\\s*","<ip>",".*","</ip>\n\\s*",
                                           "<obj>",".*","</obj>\n\\s*",
                                           "<fn>",".*","</fn>\n\\s*",
                                            "<dir>",path=".*.src","</dir>\n\\s*",
                                           "<file>",file=".*","</file>\n\\s*",
                                           "<line>",line=".*","</line>\n\\s*","</frame>\n")
          if(nrow(stack.msg)){
            err.trace=paste0(stack.msg$file," : ",stack.msg$line)
          }else{err.trace="NA"}
          address.msg <- nc::capture_all_str(error.row,"<auxwhat>",address=".*?","</auxwhat>\n",
                                             "<stack>\n\\s*?",stack="(?:.+\n)*?")
          #print(address.msg)
          #address=address.msg$address
          #print("address")
          #print(address.msg$address)
          print(length(address.msg$stack))
          if(length(address.msg$stack) > 0){
          stack.msg<-nc::capture_all_str(address.msg$stack,"<frame>\n\\s*","<ip>",".*","</ip>\n\\s*",
                                         "<obj>",".*","</obj>\n\\s*",
                                        "<fn>",".*","</fn>\n\\s*",
                                       "<dir>",path=".*.src","</dir>\n\\s*",
                                       "<file>",file=".*","</file>\n\\s*",
                                       "<line>",line=".*","</line>\n\\s*","</frame>\n")
          }
          if(nrow(stack.msg)){
            add.trace=paste0(stack.msg$file," : ",stack.msg$line)
          }
        }else{
          #print("not in auxwhat")
          address="No address trace found"
          stack.msg<- nc::capture_first_vec(stack.rows,"<frame>\n\\s*","<ip>",".*","</ip>\n\\s*",
                "<obj>",".*","</obj>\n\\s*",
                "<fn>",".*","</fn>\n\\s*",
                "<dir>",path=".*.src","</dir>\n\\s*",
                "<file>",file=".*","</file>\n\\s*",
                "<line>",line=".*","</line>\n\\s*","</frame>\n",nomatch.error=FALSE)
          err.trace<-paste0(stack.msg$file," : ",stack.msg$line)
        }
      }
      issue.dt.list[[i]] <- data.table(kind=kind$kinds,
                                       msg=gsub("<what>|</what>","",kind$msg), 
                                       errortrace=err.trace,
                                       address=address,
                                       trace=add.trace)
      
      
    }  
  }else{  
    log_text <- paste0(log,"_text")
    issue.dt.list<-nc::capture_all_str(log_text,"ERROR: ",err.msg=".*")
    if(nrow(issue.dt.list)){
      return(issue.dt.list)
    }
  }
  return(issue.dt.list)
}
