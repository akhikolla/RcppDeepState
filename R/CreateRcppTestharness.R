##' @title  creates testharness for given functions in package
##' @param package_name to the RcppExports file
##' @export
deepstate_pkg_create<-function(package_name){  
  list.paths <-nc::capture_first_vec(package_name, "/",root=".+?","/",remain_path=".*")
  p <- nc::capture_all_str(list.paths$remain_path,val=".+/",folder=".+/",packagename=".*")
  functions.list <- get_function_body(package_name)
  prototypes_calls <-get_prototype_calls(package_name)
  in_package <- paste("RcppDeepState")
  dir.create(paste0("/",list.paths$root,"/",p$val,"testfiles","/",p$packagename), showWarnings = FALSE)
  includes <-"#include @DeepState.hpp@
#include <RInside.h>
#include <iostream>
#include @RcppDeepState.h@
#include <fstream>"
  include<-gsub("@","\"",includes)
  fun_names <- unique(functions.list$funName)
  for(function_name.i in fun_names){
    write_to_file <- ""
    functions.rows  <- functions.list [functions.list$funName == function_name.i,]
    pt <- prototypes_calls[prototypes_calls$funName == function_name.i,]
    fun_name <-gsub("rcpp_","",function_name.i)
    filename <-paste0(fun_name,"_DeepState_TestHarness",".cpp")
    file.create(paste0("/",list.paths$root,"/",p$val,"testfiles","/",p$packagename,"/",filename), recursive=TRUE)
    write(include,paste0("/",list.paths$root,"/",p$val,"testfiles","/",p$packagename,"/",filename),append = TRUE)
    write_to_file <-paste(write_to_file,pt[1,pt$prototype])
    testname<-paste(function_name.i,"_test",sep="")
    unittest<-gsub(" ","",paste(fun_name,"_random_datatypes"))
    write_to_file <- paste0(write_to_file,"\n","TEST(",unittest,",",testname,")","{","\n")
    #obj <-gsub( "\\s+", " " ,paste(in_package,tolower(in_package),";","\n"))
    #write(obj,filename,append = TRUE)
    for(filestream.j in 1:nrow( functions.rows )){
      write_to_file<-paste0(write_to_file,"std::ofstream ", functions.rows[filestream.j,argument.name],"_stream",";\n")
    }
    write_to_file<-paste(write_to_file,"RInside();\n")
    create_makefile(package_name,fun_name) 
    for(argument.i in 1:nrow(functions.rows)){
      variable <- gsub( "\\s+", " " ,paste( functions.rows [argument.i,argument.type],
                                            functions.rows [argument.i,argument.name]))
      variable <- gsub("const","",variable)
      name <- (gsub("const Rcpp::","", functions.rows[argument.i,argument.type]))
      st_val <- paste0("= ","RcppDeepState_",(name),"()",";\n")
      file_open <- gsub("# ","\"",paste0( functions.rows [argument.i,argument.name],"_stream.open(#", functions.rows [argument.i,argument.name],"# );","\n",
                                          functions.rows [argument.i,argument.name],"_stream<<", functions.rows [argument.i,argument.name],";","\n",
                                          "std::cout <<","#",functions.rows [argument.i,argument.name]," values:","#"," <<",functions.rows [argument.i,argument.name]," << std::endl;","\n",
                                          functions.rows [argument.i,argument.name],"_stream.close();","\n"))
      write_to_file <-paste(write_to_file,variable,st_val,file_open)
    }
    write_to_file<-paste(write_to_file,"try{\n", sub("\\)","",sub("\\(","",pt[1,calls])))
    write_to_file<-gsub("#","\"",paste0(write_to_file,"\n","}\n","catch(Rcpp::exception& e){\n","std::cout<<#Exception Handled#<<std::endl;\n}"))
    write_to_file<-paste(write_to_file,"\n","}")
    write(write_to_file,paste0("/",list.paths$root,"/",p$val,"testfiles","/",p$packagename,"/",filename),append=TRUE)
  }
  return ("Testharness created!!") 
}   
##' @title  creates makefiles for above created testharness in package
##' @param package to the RcppExports file*
##' @param fun_name name of function to get makefile
##' @export
create_makefile <-function(package,fun_name){
  list.paths <-nc::capture_first_vec(package, "/",root=".+?","/",remain_path=".*")
  p <- nc::capture_all_str(list.paths$remain_path,val=".+/",folder=".+/",packagename=".*")
  write_to_file <- ""
  makefile.name <- gsub("rcpp_","",paste0(fun_name,".Makefile"))
  test_harness <- gsub("rcpp_","",paste0(fun_name,"_DeepState_TestHarness"))
  makefile.name.o <-paste0(test_harness,".o")
  makefile.name.cpp <-paste0(test_harness,".cpp")
  file.create(paste0("/",list.paths$root,"/",p$val,"testfiles","/",p$packagename,"/",makefile.name), recursive=TRUE)
  path <-paste("R_HOME=",R.home())
  write_to_file<-paste0(write_to_file,path,"\n")
  flags <- paste0("COMMON_FLAGS = ",paste0("/",list.paths$root,"/",p$val,"testfiles","/",p$packagename,"/",makefile.name.o)," -I",system.file("include/deepstate",package="RcppDeepState")," -L/usr/local/lib/R/site-library/RInside/lib -Wl,-rpath=/usr/local/lib/R/site-library/RInside/lib -L${R_HOME}/lib -Wl,-rpath=${R_HOME}/lib"," -L",system.file("extdata",package="RcppDeepState")," -Wl,-rpath=",system.file("extdata",package="RcppDeepState")," -lR -lRInside -ldeepstate")
  write_to_file<-paste(write_to_file,flags,"\n")
  write_to_file<-paste0(write_to_file,"\n",paste0("/",list.paths$root,"/",p$val,"testfiles","/",p$packagename,"/",test_harness)," : ",paste0("/",list.paths$root,"/",p$val,"testfiles","/",p$packagename,"/",makefile.name.o))
  compile.line <- paste("\n\t","clang++ -o",paste0("/",list.paths$root,"/",p$val,"testfiles","/",p$packagename,"/",test_harness),"${COMMON_FLAGS}")
  obj.file.path<-gsub(" ","",paste0(package,"/src/*.o"))
  write_to_file<-paste(write_to_file,compile.line,obj.file.path)
  dir.create(paste0("/",list.paths$root,"/",p$val,"testfiles","/",p$packagename,"/",fun_name,"_output"), showWarnings = FALSE)
  write_to_file<-paste0(write_to_file,"\n\t","cd ",paste0("/",list.paths$root,"/",p$val,"testfiles","/",p$packagename)," && ","valgrind --tool=memcheck --leak-check=yes ","./",test_harness," --fuzz --fuzz_save_passing --output_test_dir ","/",list.paths$root,"/",p$val,"testfiles","/",p$packagename,"/",gsub("rcpp_","",fun_name),"_output"," > ","/",list.paths$root,"/",p$val,"testfiles","/",p$packagename,"/",gsub("rcpp_","",fun_name),"_log ","2>&1")
  #write_to_file<-paste0(write_to_file,"\n\t","cd ",paste0("/home/",p$val,"testfiles","/",p$packagename)," && ","./",test_harness," --fuzz")
  write_to_file<-paste(write_to_file,"\n",paste0("/",list.paths$root,"/",p$val,"testfiles","/",p$packagename,"/",makefile.name.o),":",paste0("/",list.paths$root,"/",p$val,"testfiles","/",p$packagename,"/",makefile.name.cpp))
  write_to_file<-paste0(write_to_file,"\n\t","clang++ -I${R_HOME}/include -I/usr/local/lib/R/site-library/Rcpp/include -I/usr/local/lib/R/site-library/RInside/include"," -I",system.file("include",package="RcppDeepState")," ", 
                        paste0("/",list.paths$root,"/",p$val,"testfiles","/",p$packagename,"/",makefile.name.cpp)," -o ",paste0("/",list.paths$root,"/",p$val,"testfiles","/",p$packagename,"/",makefile.name.o)," -c")
  write(write_to_file,paste0("/",list.paths$root,"/",p$val,"testfiles","/",p$packagename,"/",makefile.name),append=TRUE)
}



globalVariables(c("argument.name","funName","argument.type","calls"
                  ,"code","funName",".","error.i","src.file.lines",
                  "heapsum","file.line","arg.name","value",":=",".N","f","fun_name"
                  ,"read.table"))