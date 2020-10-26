##' @title  analyze the binary for one function 
##' @param fun_path function path to run
##' @param max_inputs input arguments
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
  return(paste0(first.file, ':', first.line))
}
for(f.xml in c(log)){
  xml.lines <- readLines(f.xml)
  out.i <- grep("</valgrindoutput>", xml.lines)
  xml.lines.some <- if(1 < length(out.i)){
    xml.lines[ -out.i[1] ]
  }else{
    xml.lines
  }
  xml.tree <- xml2::read_xml(paste(xml.lines.some, collapse = "\n"))
src.function <- xml_text(xml_find_all(xml.tree,".//argv//exe"))
src.function <- nc::capture_all_str(src.function,"./",
                                    file=".*","_DeepState_TestHarness")
src.dir.xpath <- sprintf(".//fn[contains(text(),'%s')]", src.function$file)
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
    address <- xml_text(xml_find_first(err.node,".//auxwhat"))
    if(!is.na(address)){
      rs <- xml_child(err.node,".//auxwhat")
      stack.nodes.rs <- xml2::xml_find_all(stack.nodes[length(stack.nodes)], ".//stack")
      add.ret = stack.trace(stack.nodes.rs,src.dir.xpath)
    }else{address="No address found"}
    
    stack.nodes <- xml2::xml_find_all(err.node, ".//stack")
    count = 0
    for(s.node in stack.nodes){
        ret = stack.trace(s.node,src.dir.xpath)
     if(length(ret)){
       count = count + 1
     }
        #if(gsub(" ","",add.ret) == ":"){address.trace="No address trace found"}
      line.num.dt.list[[length(line.num.dt.list)+1]] <- data.table(
        problem=kind,
        message=msg,
        file.line=paste0(ret),
        address.msg=address,
        address.trace=add.ret)
      if(count == 1){break}
    }
    
  }
}
(line.num.dt <- do.call(rbind, line.num.dt.list))
line.num.dt<-unique(line.num.dt, incomparables = FALSE)
return(line.num.dt)

}