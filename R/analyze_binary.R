##' @title  analyze the binary file 
##' @param path to test
##' @return returns a list of all the param values of the arguments of function
##' @import methods
##' @import Rcpp
##' @import RInside
##' @import qs
##' @export
deepstate_harness_analyze_one <- function(path){
  path <-normalizePath(path, mustWork=TRUE)
  package_name <- sub("/$","",path)
  inst_path <- file.path(package_name, "inst")
  if(!dir.exists(inst_path)){
    dir.create(inst_path)
  }
  test_path <- file.path(inst_path,"testfiles")
  packagename <- basename(package_name)
  test.files <- Sys.glob(paste0(test_path,"/*"))
  for(pkg.i in seq_along(test.files)){
    pkg.path <- test.files[[pkg.i]] 
    bin.path <- file.path(paste0(pkg.path,"/",basename(pkg.path),"_output"))
    bin.files <- Sys.glob(paste0(bin.path,"/*"))
    print(bin.files)
    for(bin.i in seq_along(bin.files)){
      bin.path.i <- bin.files[[bin.i]]
      print(bin.path.i)
      fun <- basename(pkg.path) 
      exec <- paste0("./",fun,"_DeepState_TestHarness")
      inputs.path <- Sys.glob(paste0(file.path(pkg.path,"inputs"),"/*"))
      output_folder<-paste0(dirname(bin.path.i),"/log_",sub('\\..*', '',basename(bin.path.i)))
      dir.create(output_folder,showWarnings = FALSE)
      analyze_one <- paste0("valgrind --xml=yes --xml-file=",output_folder,"/valgrind_log " ,"--tool=memcheck --leak-check=yes ",exec," --input_test_file ",bin.path.i," > ",output_folder,"/valgrind_log_text"," 2>&1")
      var <- paste("cd",pkg.path,";", analyze_one) 
      #print(var)
      system(var)
      file.copy(inputs.path,output_folder)
      file.copy(bin.path.i,output_folder)
      logtable <- deepstate_logtest(file.path(output_folder,"valgrind_log"))
      if(length(logtable) > 1 && !is.null(logtable)){
      for(inputs.i in seq_along(inputs.path)){
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
      }else{
      cat(sprintf("\nanalyzed binary - found no issues\n"))
    }
      
    }
  }
}


globalVariables(c("argument.name","funName","argument.type","calls"
                  ,"code","funName",".","error.i","src.file.lines",
                  "heapsum","file.line","arg.name","value",":=",".N","f","fun_name"
                  ,"read.table","new.i.vec","download.file","result","inputs",
                  "rest"))

globalVariables(c("error.i","error.type","sanitizer","function.i",
                  "src.file.lines","heapsum","file.line","arg.name",
                  "value",".N",":=","prototype"))

