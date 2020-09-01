##' @title  creates list of files and path for given functions in package
##' @param path to the package test file
##' @return makefiles.list makefile list 
##' @export
deepstate_harness_files <- function(path){
  functions.list <-  RcppDeepState::deepstate_get_function_body(path)
  inst_path <- file.path(path, "inst")
  test_path <- file.path(inst_path,"testfiles")
  fun_names <- unique(functions.list$funName)
  harnessfiles.list = list()
  makefiles.list=list()
  i<-1
  for(function_name.i in fun_names){
    harnessfiles.list[[i]] <- gsub("rcpp_","",paste0(test_path,"/",function_name.i,"_DeepState_TestHarness.cpp"))
    makefiles.list[[i]] <-  gsub("rcpp_","",paste0(test_path,"/",function_name.i,".Makefile"))
    i = i + 1
  }
  return(c(harnessfiles.list,makefiles.list))
}

##' @title  creates list of log files
##' @param path to the package test file
##' @return logfiles.list logfile path list
##' @export
deepstate_list_log_files <- function(path){
  functions.list <-  RcppDeepState::deepstate_get_function_body(path)
  inst_path <- file.path(path, "inst")
  test_path <- file.path(inst_path,"testfiles")
  fun_names <- unique(functions.list$funName)
  logfiles.list = list()
  i<-1
  for(function_name.i in fun_names){
    logfiles.list[[i]] <- gsub("rcpp_","",paste0(test_path,"/",function_name.i,"/",function_name.i,"_log"))
    i = i + 1
  }
  return(logfiles.list)
}

##' @title  creates list of log files
##' @param path to the package test file
##' @return bindir.list returns binary folder paths
##' @export
deepstate_list_bin_directory <- function(path){
  functions.list <- deepstate_get_function_body(path)
  inst_path <- file.path(path, "inst")
  test_path <- file.path(inst_path,"testfiles")
  fun_names <- unique(functions.list$funName)
  bindir.list = list()
  i<-1
  for(function_name.i in fun_names){
    bindir.list[[i]] <- gsub("rcpp_","",paste0(test_path,"/",function_name.i,"_output"))
    i = i + 1
  }
  return(bindir.list)
}


##' @title  creates list of log files
##' @param path to the package test file
##' @return list.args.i returns args path list
##' @export
deepstate_list_package_args <- function(path){
  body.list <- deepstate_get_function_body(path)
  inst_path <- file.path(path, "inst")
  test_path <- file.path(inst_path,"testfiles")
  list.args = gsub(" ","",body.list$argument.name)
  list.args.i=list()
  i<-1
  for(args.i in list.args){
    list.args.i[[i]]<-file.path(test_path,args.i)
    print(list.args.i[[i]])
    i = i + 1
  }
  return(list.args.i)
}
