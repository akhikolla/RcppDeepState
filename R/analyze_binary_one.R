##' @title  compile the  for one function 
##' @param fun_path function path to run
##' @export
deepstate_compile_fun<-function(fun_path,max_inputs="all"){
  compile_line <-paste0("cd ",fun_path," && rm -f *.o && make\n")
  if(file.exists(file.path(fun_path,paste0(basename(fun_path),"_DeepState_TestHarness.cpp"))) && 
     file.exists(file.path(fun_path,"Makefile"))){
    cat(sprintf("executing .. \n%s\n",compile_line))
    system(compile_line)
    if(file.exists(file.path(fun_path, paste0(basename(fun_path), "_DeepState_TestHarness")))){
      deepstate_analyze_fun(fun_path,max_inputs)
      return(basename(fun_path))
    }
    else{
      return("failed")
    } 
  }
  
}

##' @title  analyze the binary for one function 
##' @param fun_path function path to run
##' @export
deepstate_analyze_fun<-function(fun_path,max_inputs){
    pkg.path <- fun_path
    bin.path <- file.path(paste0(pkg.path,"/",basename(pkg.path),"_output"))
    bin.files <- Sys.glob(paste0(bin.path,"/*"))
    print(bin.files)
    if(max_inputs != "all" && max_inputs <= length(bin.files) && length(bin.files) > 0){
      bin.files <- bin.files[1:max_inputs]
    } 
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
      file.copy(bin.path.i,output_folder)
      #logtable <- deepstate_logtest(file.path(output_folder,"valgrind_log"))
      #print(logtable)
      if(length(logtable) > 1 && !is.null(logtable)){
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
      }else{
        message(sprintf("\nanalyzed binary - found no issues\n"))
      }
      
    }
}



