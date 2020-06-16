##' @title  analyze the binary file 
##' @param packagename to test
##' @param function_name to the RcppExports file
##' @param binary_file binary file containing the output
##' @return returns a list of all the param values of the arguments of function
##' @export
deep_harness_analyze_one <- function(packagename,function_name,binary_file){
  fun_name <-gsub("rcpp_","",function_name)
  exec.path <- system.file("RcppDeepStatefiles/binsegRcpp", package= "RcppDeepState")
  exec <- paste0("./",fun_name,"_DeepState_TestHarness")
  binary_file=system.file("RcppDeepStatefiles/binsegRcpp/binseg_normal_output/dd5b1543eccdc54b284c00142df7f40c1583ac68.crash",package="RcppDeepState")
  analyze_one <- paste0(";",exec," --input_test_file ",binary_file)
  var <- paste("cd",exec.path,analyze_one) 
  system(var)
  functions.list  <- get_function_body(packagename)
  counter = 1
  #function_name = "rcpp_read_out_of_bound"
  arguments.list = list()
  arguments.name = list()
  for(function_name.i in unique(functions.list$funName)){ 
    if(function_name.i == function_name){
      functions.rows  <- functions.list [functions.list$funName == function_name.i,] 
      for(argument.i in 1:nrow(functions.rows)){
        arg.name = gsub(" ","",paste0(functions.rows[argument.i,argument.name]))
        #print(arg.name)
        filepath=paste0(system.file("RcppDeepStatefiles/binsegRcpp",package = "RcppDeepState"),"/",arg.name)
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