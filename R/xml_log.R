##' @title Parse xml data 
##' @param xml.file the input log file path
##' @return line.num.dt list with error messgae,line number where the error ocuured
##' @import data.table
##' @import xml2
##' @description Generates a data table with valgrind error message, address trace 
##' and the line number and file name where the issue occured
##' @export
deepstate_read_valgrind_xml <- function(xml.file){
  xml.lines <- readLines(xml.file)
  out.i <- grep("</valgrindoutput>", xml.lines)
  xml.lines.some <- if(1 < length(out.i)){
    xml.lines[ -out.i[1] ]
  }else{
    xml.lines
  }
  xml.tree <- xml2::read_xml(paste(xml.lines.some, collapse = "\n"))
  src.function <- xml_text(xml_find_all(xml.tree,".//argv//exe"))
  arg.file <- sprintf(".//arg[contains(text(),'%s')]", "--xml-file")
  logs <- xml_text(xml_find_all(xml.tree,arg.file))
  path.to.find <- nc::capture_first_vec(logs,"--xml-file=",
                                        file=".*","/inst/testfiles/.*")
  src.dir <- paste0(path.to.find$file,"/src")
  src.dir.xpath <-if(length(grep(src.dir,readLines(xml.file)))){
    sprintf(".//dir[text()='%s']", src.dir)
  }else if(length(grep("<file>src/",readLines(xml.file)))){
    sprintf(".//file[contains(text(),'%s')]", "src/")
  }else{
    return(data.table(err.kind=character(), message=character(), file.line=character(), address.msg=character(),address.trace=character()))
  }
  
  line.num.dt.list <- list()
  error.nodes <- xml2::xml_find_all(xml.tree, "//error")
  for(err.node in error.nodes){
    kind <- get_string(err.node, "kind")
    xwhat <- get_string(err.node,"xwhat")
    msg <-if(length(xwhat)){
      xml_text(xml_find_all(err.node,".//xwhat//text"))
    }else{
      get_string(err.node,"what")  
    }
    stack.nodes <- xml2::xml_find_all(err.node, ".//stack")
     add.ret="No Address Trace found"
    address <- xml_text(xml_find_first(err.node,".//auxwhat"))
    if(!is.na(address)){
      rs <- xml_child(err.node,".//auxwhat")
      add.ret<-address.trace(err.node)
      if(!is.null(add.ret) && add.ret == "stack"){
        add.ret = stack.trace(stack.nodes[length(stack.nodes)],src.dir.xpath)
        stack.nodes <- stack.nodes[-length(stack.nodes)]
      }else{add.ret="No Address Trace found"}
    }else{address="No Address found"}
    for(s.node in stack.nodes){
      ret = stack.trace(s.node,src.dir.xpath)
      if(!is.na(ret)){
        line.num.dt.list[[length(line.num.dt.list)+1]] <- data.table(
          err.kind=kind,
          message=msg,
          file.line=ret,
          address.msg=address,
          address.trace=add.ret)  
      }
    }
  }
  line.num.dt <- do.call(rbind, line.num.dt.list)
  line.num.dt<-unique(line.num.dt, incomparables = FALSE)
}

##' @title identify the stack trace with error
##' @param s.node stack frame
##' @param src.dir.xpath gives path to the src file
##' @return trace with the error
stack.trace <- function(s.node,src.dir.xpath){
  first.dir <- xml2::xml_find_first(s.node, src.dir.xpath)
  first.frame <- xml2::xml_parent(first.dir)
  first.file <- get_string(first.frame, "file")
  first.line <- get_string(first.frame, "line")
  trace <- if(length(first.line) > 0 && length(first.file) >0){
     paste0(first.file, ' : ', first.line)
  }else{
      NA_character_
  }
}

##' @title identify the address trace with error
##' @param err.node error node
##' @return stack if stack trace found else the aux  
address.trace<-function(err.node){
  childs <- as_list(err.node)
  if(any(names(childs)=="auxwhat")){
    aux.val <- which(names(childs)=="auxwhat")
    stack.val <- names(childs)[aux.val+1] == "stack"
      output <- if(!is.na(stack.val) && stack.val[1] == TRUE)
     "stack"
  }else{
    NA_character_
  }
} 


##' @title get child node contents
##' @param node with the child
##' @param child node
get_string <- function(node, child){
  paste(xml2::xml_contents(xml2::xml_child(node, child)))
}

  
