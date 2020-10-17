##' @title  deepstate_logtest
##' @param log file to parse
##' @import nc
##' @export
deepstate_logtest <- function(log){
     issue.dt.list <- list()
     if(length(logtable) > 0 && !is.null(logtable)){
       for(inputs.i in seq_along(inputs.path)){
         file.copy(inputs.path[[inputs.i]],output_folder)
         if(grepl(".qs",inputs.path[[inputs.i]],fixed = TRUE)){
           cat(sprintf("\nInput parameter from qs - %s\n",gsub(".qs","",basename(inputs.path[[inputs.i]]))))
           qread.data <- qread(inputs.path[[inputs.i]])
           print(qread.data)   
         }
         else{
           cat(sprintf("\nInput parameter - %s\n",basename(inputs.path[[inputs.i]])))
           print(scan(inputs.path[[inputs.i]]))
         }
       }
       print(logtable)
     }else{
       message(sprintf("\nanalyzed binary - found no issues\n"))
     }
     
    if(length(grep("<file>src/",readLines(log)))){
       trace <- list("<frame>\n\\s*","<ip>",".*","</ip>\n\\s*",
                     "<obj>",".*","</obj>\n\\s*",
                     "<fn>",".*","</fn>\n\\s*",
                     "<dir>",path=".*","</dir>\n\\s*",
                     "<file>",file="src.*","</file>\n\\s*",
                     "<line>",line=".*","</line>\n\\s*","</frame>\n")
     }else{
       trace <- list("<frame>\n\\s*","<ip>",".*","</ip>\n\\s*",
                     "<obj>",".*","</obj>\n\\s*",
                     "<fn>",".*","</fn>\n\\s*",
                     "<dir>",path=".*.src","</dir>\n\\s*",
                     "<file>",file=".*","</file>\n\\s*",
                     "<line>",line=".*","</line>\n\\s*","</frame>\n")
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
      add.trace="NA"
      address="NA"
      if(length(stack.rows)){
        if(any(grep("<auxwhat>",error.row,fixed = TRUE))){
          stack.msg <- nc::capture_all_str(stack.rows,trace)
          if(nrow(stack.msg)){
            err.trace=paste0(stack.msg$file," : ",stack.msg$line)
          }else{err.trace="NA"}
          address.trace <- nc::capture_all_str(error.row,"<auxwhat>",address=".*","</auxwhat>\n")
          address=address.trace$address
          if(nrow(address.trace)){
            address.msg <- nc::capture_all_str(error.row,"<auxwhat>",address=".*","</auxwhat>\n\\s*",
                                                 "<stack>\n\\s*",stack="(?:.*\n)+","\\s*</stack>")
          }
          if(length(address.msg$stack) > 0){
          add.stack.msg<-nc::capture_all_str(address.msg$stack,trace)
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
  }else{  
    log_text <- paste0(log,"_text")
    issue.dt.list<-nc::capture_all_str(log_text,"ERROR: ",err.msg=".*")
    if(nrow(issue.dt.list)){
      return(issue.dt.list)
    }
  }
  return(issue.dt.list)
}
