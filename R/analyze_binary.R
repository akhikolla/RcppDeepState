##' @title  analyze the binary file 
##' @param path to test
##' @import Rcpp
##' @import methods
##' @return returns a list of all the param values of the arguments of function
##' @export
deep_harness_analyze_one <- function(path){
  list.paths <-nc::capture_first_vec(path, "/",root=".+?","/",remain_path=".*")
  path_details <- nc::capture_all_str(list.paths$remain_path,val=".+/",folder=".+/",package_name=".+/",fun.name=".+/",binary_file=".*")
  exec.path <- paste0("/",list.paths$root,"/",path_details$val,path_details$folder,path_details$package_name," ;")
  fun <- gsub("_output/","",path_details$fun.name)
  exec <- paste0("./",fun,"_DeepState_TestHarness")
  binary_file<-paste0("/",list.paths$root,"/",path_details$val,path_details$folder,path_details$package_name,path_details$fun.name,path_details$binary_file)
  analyze_one <- paste0(exec," --input_test_file ",binary_file)
  var <- paste("cd",exec.path,analyze_one) 
  package_path <- paste0("/",list.paths$root,"/",path_details$val,"testpkgs/",path_details$package_name)
  #print(var)
  #system(var)
  functions.list  <- get_function_body(package_path)
  #print(functions.list)
  counter = 1
  #function_name = "rcpp_read_out_of_bound"
  arguments.list = list()
  arguments.name = list()
  for(function_name.i in unique(functions.list$funName)){ 
    #print(fun)
    if(function_name.i == paste0("rcpp_",fun)){
      functions.rows  <- functions.list [functions.list$funName == function_name.i,] 
      for(argument.i in 1:nrow(functions.rows)){
        arg.name = gsub(" ","",paste0(functions.rows[argument.i,argument.name]))
        #print(arg.name)
        filepath=paste0("/",list.paths$root,"/",path_details$val,"testfiles/",path_details$package_name,arg.name)
        #print(paste0("/",list.paths$root,"/",path_details$val,"testfiles/",path_details$package_name,arg.name))
        cat("\n", file = filepath, append = TRUE)
        values = read.table(filepath,sep="\t")
        #names(arguments.list) = c(arg.name)
        #arguments.list <- (arguments.list,arg.name=list(values))
        arguments.list[counter] = list(values)
        names(arguments.list[counter]) = arg.name
        arguments.name[counter] = arg.name
        counter = counter+1
        
      }
      names(arguments.list) = arguments.name
    }
  }
  return(arguments.list)
}