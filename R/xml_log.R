##' @title  return datatable for parse xml data 
##' @param log the input log file path
##' @import xml2
##' @export
deepstate_xmlog <- function(log){
  get_string <- function(node, child){
    paste(xml2::xml_contents(xml2::xml_child(node, child)))
  }
  stack.trace <- function(s.node,src.dir.xpath){
    first.dir <- xml2::xml_find_first(s.node, src.dir.xpath)
    first.frame <- xml2::xml_parent(first.dir)
    first.file <- get_string(first.frame, "file")
    first.line <- get_string(first.frame, "line")
    if(length(first.line) > 0 && length(first.file) >0){
      return(paste0(first.file, ' : ', first.line))
    }else{return("NA")}
  }
  address.trace<-function(err.node){
    childs <- as_list(err.node)
    names.list <- c(names(childs))
    if(any(names.list=="auxwhat")){
      vals <- which(names.list=="auxwhat")
      #print("val")
      val = (names.list[vals+1] == "stack")
      #print(val)
      if(!is.na(val) && val == TRUE)
        return(1)
    }else{return(-1)}
  } 
  xml.lines <- readLines(log)
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
  #print("xml fil")
  #print(logs)
  path.to.find <- nc::capture_first_vec(logs,"--xml-file=",
                                        file=".*","/inst/testfiles/.*")
  src.dir <- paste0(path.to.find$file,"/src")
  if(length(grep(src.dir,readLines(log)))){
    src.dir.xpath <- sprintf(".//dir[text()='%s']", src.dir)
  }else if(length(grep("<file>src/",readLines(log)))){
    src.dir.xpath <- sprintf(".//file[contains(text(),'%s')]", "src/")
  }else{
    return("No source trace found")
  }
  
  line.num.dt.list <- list()
  error.nodes <- xml2::xml_find_all(xml.tree, "//error")
  for(err.node in error.nodes){
    kind <- get_string(err.node, "kind")
    xwhat <- get_string(err.node,"xwhat")
    if(length(xwhat)){
      msg <-  xml_text(xml_find_all(err.node,".//xwhat//text"))
    }else{
      msg <- get_string(err.node,"what")  
    }
    stack.nodes <- xml2::xml_find_all(err.node, ".//stack")
    #print(length(stack.nodes))
    #print(stack.nodes[2])
    add.ret="No Address Trace found"
    address <- xml_text(xml_find_first(err.node,".//auxwhat"))
    if(!is.na(address)){
      rs <- xml_child(err.node,".//auxwhat")
      add.ret<-address.trace(err.node)
      #print(add.ret)
      if(!is.null(add.ret) && add.ret == 1){
        print("entered")
        add.ret = stack.trace(stack.nodes[length(stack.nodes)],src.dir.xpath)
      }else{add.ret="No Address Trace found"}
    }else{address="No Address found"}
    stack.nodes <- xml2::xml_find_all(err.node, ".//stack")
    count = 0
    ret="NA"
    for(s.node in stack.nodes){
      ret = stack.trace(s.node,src.dir.xpath)
      if(length(ret)){
        count = count + 1
      }
      #if(gsub(" ","",add.ret) == ":"){address.trace="No address trace found"}
      #print(add.ret)
      line.num.dt.list[[length(line.num.dt.list)+1]] <- data.table(
        err.kind=kind,
        message=msg,
        file.line=ret,
        address.msg=address,
        address.trace=add.ret)
      if(count == 1){break}
    }
  }
  #print(line.num.dt.list)
  (line.num.dt <- do.call(rbind, line.num.dt.list))
  line.num.dt<-unique(line.num.dt, incomparables = FALSE)
  return(line.num.dt)
  
}