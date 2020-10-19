##' @title  analyze the binary for one function 
##' @param fun_path function path to run
##' @param max_inputs input arguments
##' @export
deepstate_analyze_fun<-function(fun_path,max_inputs){
    pkg.path <-normalizePath(fun_path, mustWork=TRUE) 
    bin.path <- file.path(pkg.path,paste0(basename(pkg.path),"_output"))
    bin.files <- Sys.glob(file.path(bin.path,"*"))
    #print(bin.files)
    if(max_inputs != "all" && max_inputs <= length(bin.files) && length(bin.files) > 0){
      bin.files <- bin.files[1:max_inputs]
    }
    else{
      if(length(bin.files) > 3){ 
        bin.files <- bin.files[1:3] 
      }
    }
    for(bin.i in seq_along(bin.files)){
      bin.path.i <- bin.files[[bin.i]]
      #print(bin.path.i)
      inputs.path <- Sys.glob(file.path(pkg.path,"inputs/*"))
      output_folder<-file.path(dirname(bin.path.i),paste0("log_",sub('\\..*', '',basename(bin.path.i))))
      logtable <-  deepstate_analyze_file(bin.path.i)
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
      
    }
}


##' @title  analyze the binary for one function 
##' @param files.path file to analyze
##' @export
deepstate_analyze_file<-function(files.path){
  print(files.path)
  files.path <-normalizePath(files.path, mustWork=TRUE)
  exec <- paste0("./",gsub("_output","_DeepState_TestHarness",basename(dirname(files.path)))) 
  print(exec)
  output_folder<-file.path(dirname(files.path),paste0("log_",sub('\\..*', '',basename(files.path))))
  print(output_folder)
  dir.create(output_folder,showWarnings = FALSE)
  valgrind.log <- file.path(output_folder,"valgrind_log")
  valgrind.log.text <- file.path(output_folder,"valgrind_log_text")
  analyze_one <- paste0("valgrind --xml=yes --xml-file=",valgrind.log," --tool=memcheck --leak-check=yes ",exec," --input_test_file ",files.path," > ",valgrind.log.text," 2>&1")
  var <- paste("cd ",dirname(dirname(files.path)),";", analyze_one) 
  print(var)
  #system(var)
  logtable <- deepstate_logtest(file.path(output_folder,"valgrind_log"))
  return(logtable)
}  

