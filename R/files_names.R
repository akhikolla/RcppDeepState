##' @title  creates list of files and path for given functions in package
##' @param path to the package test file
##' @export
harness_files <- function(path){
  functions.list <- get_function_body(path)
  p <- nc::capture_all_str(gsub("/home/","",path),val=".+/",folder=".+/",packagename=".*")
  fun_names <- unique(functions.list$funName)
  harnessfiles.list = list()
  makefiles.list=list()
  i<-1
  for(function_name.i in fun_names){
    filepaths<-paste0("/home/",p$val,"testfiles/",p$packagename,"/")
    harnessfiles.list[[i]] <- gsub("rcpp_","",paste0(filepaths,function_name.i,"_DeepState_TestHarness.cpp"))
    makefiles.list[[i]] <-  gsub("rcpp_","",paste0(filepaths,function_name.i,".Makefile"))
    i = i + 1
  }
 return(c(harnessfiles.list,makefiles.list))
}

##' @title  creates list of log files
##' @param path to the package test file
##' @export
list_log_files <- function(path){
  functions.list <- get_function_body(path)
  p <- nc::capture_all_str(gsub("/home/","",path),val=".+/",folder=".+/",packagename=".*")
  fun_names <- unique(functions.list$funName)
  logfiles.list = list()
  i<-1
  for(function_name.i in fun_names){
    filepaths<-paste0("/home/",p$val,"testfiles/",p$packagename,"/")
    logfiles.list[[i]] <- gsub("rcpp_","",paste0(filepaths,function_name.i,"_log"))
   i = i + 1
  }
  return(logfiles.list)
}

##' @title  creates list of log files
##' @param path to the package test file
##' @export
list_bin_directory <- function(path){
  functions.list <- get_function_body(path)
  p <- nc::capture_all_str(gsub("/home/","",path),val=".+/",folder=".+/",packagename=".*")
  fun_names <- unique(functions.list$funName)
  bindir.list = list()
  i<-1
  for(function_name.i in fun_names){
    filepaths<-paste0("/home/",p$val,"testfiles/",p$packagename,"/")
    bindir.list[[i]] <- gsub("rcpp_","",paste0(filepaths,function_name.i,"_output"))
    i = i + 1
  }
  return(bindir.list)
}


  