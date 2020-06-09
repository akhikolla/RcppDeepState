##' @title gets package details
##' @return function list with function names and arguments
##' @param path to the RcppExports file

get_package_details <- function(path){
  package_path <- Sys.glob(file.path(
    path,"src", "RcppExports.cpp"))
  funs<- nc::capture_all_str(
    package_path,
    "\n\\s*// ",
    commentName=".*",
    "\n",
    prototype=list(
      returnType=".*",
      " ",
      funName=".*?",
      "\\(",
      arguments=".*",
      "\\);"),"\n",
    SEXP=".*\n","\\s*BEGIN_RCPP\\s*\n",
    code="(?:.*\n)*?",
    "\\s*END_RCPP")
}

##' @title gets function body
##' @return function.list list with function names and arguments
##' @param package_name to the RcppExports file

get_function_body<-function(package_name){
  funs <- get_package_details(package_name) 
  function.list <- funs[,{
    dt <- nc::capture_all_str(
      code,
      "input_parameter< const ",
      argument.type=".*?",
      ">::type",
      argument.name="[^(]+")
  }, by=funName]
  return(function.list)
}

##' @title gets prototype calls
##' @return prototypes list with function prototype
##' @param package_name to the RcppExports file
get_prototype_calls <-function(package_name){
  funs <- get_package_details(package_name) 
  codes <- funs[,{nc::capture_all_str(code,"::wrap",calls ="(?:.*)")},by=funName]
  prototypes <-funs[,.(funName,prototype,calls=codes$calls)]
  return(prototypes)
}

##' @title  creates testharness for given functions in package
##' @param package_name to the RcppExports file
deepstate_pkg_create<-function(package_name){  
  functions.list <- get_function_body(package_name)
  prototypes_calls <-get_prototype_calls(package_name)
  in_package <- paste("RcppDeepState")
  includes <- "#include <deepstate/DeepState.hpp>
#include <RInside.h>
#include <iostream>
#include <RcppDeepState.h>
#include <fstream>"
  fun_names <- unique(functions.list$funName)
  for(function_name.i in fun_names){
    write_to_file <- ""
    functions.rows  <- functions.list [  functions.list $funName == function_name.i,]
    pt <- prototypes_calls[prototypes_calls$funName == function_name.i,]
    fun_name <-gsub("rcpp_","",function_name.i)
    filename <-gsub(" ","",paste(fun_name,"_DeepState_TestHarness",".cpp"))
    file.create((filename), recursive=TRUE)
    write(includes,filename,append = TRUE)
    write_to_file <-paste(write_to_file,pt[1,pt$prototype])
    testname<-paste(function_name.i,"_test",sep="")
    unittest<-gsub(" ","",paste(fun_name,"_random_datatypes"))
    write_to_file <- paste0(write_to_file,"\n","TEST(",unittest,",",testname,")","{","\n")
    #obj <-gsub( "\\s+", " " ,paste(in_package,tolower(in_package),";","\n"))
    #write(obj,filename,append = TRUE)
    for(filestream.j in 1:nrow( functions.rows )){
      write_to_file<-paste0(write_to_file,"std::ofstream ", functions.rows[filestream.j,argument.name],"_stream",";\n")
    }
    write_to_file<-paste(write_to_file,"int argc;","\n","char **argv;","\n","RInside R(argc,argv);\n")   
    for(argument.i in 1:nrow(functions.rows)){
      create_makefile(package_name,functions.rows[argument.i,funName]) 
      variable <- gsub( "\\s+", " " ,paste( functions.rows [argument.i,argument.type], functions.rows [argument.i,argument.name]))
      name <- (gsub("Rcpp::","", functions.rows [argument.i,argument.type]))
      st_val <- gsub(" ","",paste("=","RcppDeepState_",(name),"()",";\n"))
      file_open <- gsub("# ","\"",paste0( functions.rows [argument.i,argument.name],"_stream.open(#", functions.rows [argument.i,argument.name],"# );","\n",
                                          functions.rows [argument.i,argument.name],"_stream<<", functions.rows [argument.i,argument.name],";","\n",
                                          functions.rows [argument.i,argument.name],"_stream.close();","\n"))
      write_to_file <-paste(write_to_file,variable,st_val,file_open)
    }
    write_to_file<-paste(write_to_file,"try{\n", sub("\\)","",sub("\\(","",pt[1,calls])))
    write_to_file<-gsub("#","\"",paste0(write_to_file,"\n","}\n","catch(Rcpp::exception& e){\n","std::cout<<#Exception Handled#<<std::endl;\n}"))
    write_to_file<-paste(write_to_file,"\n","}")
    write(write_to_file,filename,append=TRUE)
  }
  return ("Testharness created!!") 
}   
#deepstate_pkg_create("~/R/binsegRcpp")

##' @title  creates makefiles for above created testharness in package
##' @param package to the RcppExports file
##' @param fun_name name of function to get makefile
create_makefile <-function(package,fun_name){
  package_name <- package
  makefile.name <- gsub("rcpp_","",paste0(fun_name,".Makefile"))
  test_harness <- gsub("rcpp_","",paste0(fun_name,"_DeepState_TestHarness"))
  makefile.name.o <-paste0(test_harness,".o")
  makefile.name.cpp <-paste0(test_harness,".cpp")
  file.create((makefile.name), recursive=TRUE)
  path <-paste("R_HOME=/home/akhila/lib/R")
  write(path,makefile.name,append = TRUE) 
  flags <- paste("COMMON_FLAGS=",makefile.name.o," -I/home/akhila/R/RcppDeepState/inst/include/ -L/usr/lib/R/site-library/RInside/include/lib -Wl,-rpath=/usr/lib/R/site-library/RInside/include/lib -L${R_HOME}/lib -Wl,-rpath=${R_HOME}/lib -L/home/akhila/deepstate/src/lib -Wl,-rpath=/home/akhila/deepstate/src/lib -lR -lRInside -ldeepstate")
  write(flags,makefile.name,append = TRUE)
  write(paste(test_harness,":",makefile.name.o),makefile.name,append = TRUE)
  compile.line <- paste("\t","clang++ -o",test_harness,"${COMMON_FLAGS}")
  obj.file.path <-gsub(" ","",paste(package_name,"/src/*.o"))
  write(paste(compile.line,obj.file.path),makefile.name,append = TRUE)
  write(paste0("\t","./",test_harness," --fuzz"),makefile.name,append = TRUE)
  write(paste(makefile.name.o,":",makefile.name.cpp),makefile.name,append = TRUE)
  write(paste("\t","clang++ -I${R_HOME}/include -I/home/akhila/deepstate/src/include -I/usr/lib/R/site-library/Rcpp/include -I/usr/lib/R/site-library/RInside/include -I/home/akhila/R/RcppDeepState/inst/include/", 
              makefile.name.cpp,"-o",makefile.name.o,"-c"),makefile.name,append = TRUE)
}

##' @title  analyze the binary file 
##' @param function_name to the RcppExports file
##' @param binary_file binary file containing the output
##' @return returns a list of all the param values of the arguments of function

deep_harness_analyze_one <- function(function_name,binary_file){
  fun_name <-gsub("rcpp_","",function_name)
  output.dir <- paste0(fun_name,"_output/",binary_file)
  analyze_one <- paste0("./",fun_name,"_DeepState_TestHarness"," --input_test_file ",output.dir)
  print(analyze_one)
  system(analyze_one)
}

#deep_harness_analyze_one("rcpp_binseg_normal","6d332a405389934d1a0bb64728ae4c3a96ec12c6.pass")
##' @title compiles the code for created testharness in package
##' @param package_name to the RcppExports file

deep_harness_compile_run <- function(package_name){
  functions.list  <- get_function_body(package_name)
  fun_names <- unique(functions.list$funName)
  for(f in fun_names){
    functions.rows  <- functions.list [functions.list $funName == f,]
    fun_name <-gsub("rcpp_","",f)
    compile_line <-paste0("rm -f *.o && make -f ",fun_name,".Makefile ",fun_name,"_DeepState_TestHarness")
    system(compile_line)
  }
} 
#deep_harness_compile_run("~/R/binsegRcpp")


##' @title  compile the code and save passing tests 
##' @param package_name for the RcppExports file
deep_harness_save_passing_tests<-function(package_name){
  functions.list  <- get_function_body(package_name)
  fun_names <- unique(functions.list $funName)
  for(f in fun_names){
    functions.rows  <- functions.list [functions.list $funName == f,]
    fun_name <-gsub("rcpp_","",f)
    output.dir <- paste0(fun_name,"_output")
    dir.create(output.dir)
    print(paste("saving passed testcases in", output.dir))
    filename <-paste0("./",fun_name,"_DeepState_TestHarness"," --fuzz --fuzz_save_passing --output_test_dir ",output.dir)
    system(filename)
  }
}

#deep_harness_save_passing_tests("~/R/binsegRcpp")
globalVariables(c("argument.name","funName","argument.type","calls","code","funName",".","error.i","src.file.lines","heapsum","file.line","arg.name","value"))
