##' @title  creates testharness for given function in package
##' @param package_name to the RcppExports file
##' @param function_name of the package
##' @export
deepstate_editable_fun<-function(package_name,function_name){
  deepstate_fun_create(package_name,function_name,sep="generation")  
  deepstate_fun_create(package_name,function_name,sep="checks")  
  }

deepstate_compile_generate_fun <-function(package_name,function_name){
  inst_path <- file.path(package_name, "inst")
  test_path <- file.path(inst_path,"testfiles")
  filename  <- paste0(function_name,"_DeepState_TestHarness_generation.cpp")
  no.specified.range <- list()
  fun_path <- file.path(test_path,function_name)
  file_path <- file.path(test_path,function_name,filename)
  makefile.path <- file.path(test_path,function_name)
  if(file.exists(fun_path)){
    harness_lines <- readLines(file_path,warn=FALSE)
    #harness_lines <- gsub("","",harness_lines,fixed=TRUE)
    range_elements <- nc::capture_all_str(harness_lines,"//",
                                          fun_call=".*","\\(")
    for(fun_range in range_elements$fun_call){
      range_check <- grep(paste0(fun_range,"();"),harness_lines,value = TRUE,fixed=TRUE)
      variable = nc::capture_all_str(range_check,val = ".*","="," RcppDeepState_",
                                     type=".*","\\(")
      #system(paste0("\"grep -e ",fun_range,"(); ",filename," | wc -l\""))
      no.specified.range[[variable$val]] <- paste(variable$val,":",variable$type)
      
      message(sprintf("The following ranges are not specified you still want to continue?"))
      print(no.specified.range)
      response <- readline(prompt="Enter y/n to continue/exit:\n")
      if(response == 'y'){
        fun_generated <- deepstate_fuzz_fun(fun_path,time.limit.seconds=2,sep="generation")
        print(fun_generated)
        final_res <- deepstate_analyze_fun(fun_path,sep="generation")
        print(final_res)
      }
    }
  }else{
    stop("Editable file doesn't exist. Run deepstate_editable_fun")
  }
}

deepstate_compile_checks_fun <-function(package_name,function_name){
  inst_path <- file.path(package_name, "inst")
  test_path <- file.path(inst_path,"testfiles")
  filename  <- paste0(function_name,"_DeepState_TestHarness_checks.cpp")
  no.specified.range <- list()
  fun_path <- file.path(test_path,function_name)
  file_path <- file.path(test_path,function_name,filename)
  makefile.path <- file.path(test_path,function_name)
  if(file.exists(fun_path)){
    harness_lines <- readLines(file_path,warn=FALSE)
     range_check <- grep("ASSERT_",harness_lines,value = TRUE,fixed=TRUE)
     if(length(range_check) == 0)
      message(sprintf("No asserts are specified you still want to continue?"))
      response <- readline(prompt="Enter y/n to continue/exit:\n")
      if(response == 'y' || length(range_check) > 0){
        fun_generated <- deepstate_fuzz_fun(fun_path,time.limit.seconds=2,sep="generation")
        print(fun_generated)
        final_res <- deepstate_analyze_fun(fun_path,sep="generation")
        print(final_res)
      }
    }else{
    stop("Editable file doesn't exist. Run deepstate_editable_fun")
  }
}