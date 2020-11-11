deepstate_fun_create <- function(package_name,functions.rows,function_name.i,pt){
  print(package_name)
  write_to_file <- ""
  inst_path <- file.path(package_name, "inst")
  test_path <- file.path(inst_path,"testfiles")
  headers <-"#include <fstream>\n#include <RInside.h>\n#include <iostream>\n#include <RcppDeepState.h>\n#include <qs.h>\n#include <DeepState.hpp>\n"
  fun_name <-function_name.i
  filename <-paste0(fun_name,"_DeepState_TestHarness",".cpp")
  fun_path <- file.path(test_path,fun_name)
if(!dir.exists(fun_path)){
  dir.create(fun_path)
}
file_path <- file.path(fun_path,filename)
file.create(file_path,recursive=TRUE)
write(headers,file_path,append = TRUE)
write_to_file <-paste0(write_to_file,pt[1,pt$prototype],"\n")
testname<-paste0(function_name.i,"_test",sep="")
unittest<-paste0(package_name,"_deepstate_test")
write_to_file <- paste0(write_to_file,"\n","TEST(",unittest,",",testname,")","{","\n")
#obj <-gsub( "\\s+", " " ,paste(in_package,tolower(in_package),";","\n"))
#write(obj,filename,append = TRUE)
indent <- "  "
write_to_file<-paste0(write_to_file,indent,"RInside R;\n",indent,"std::cout << #input starts# << std::endl;\n")
deepstate_create_makefile(package_name,fun_name) 
proto_args <-""
for(argument.i in 1:nrow(functions.rows)){
  arg.type <- gsub(" ","",functions.rows [argument.i,argument.type])
  arg.name <- gsub(" ","",functions.rows [argument.i,argument.name])
  variable <- paste0(arg.type," ",arg.name)
  variable <- gsub("const","",variable)
  type.arg <- gsub("const","", arg.type)
  type.arg <-gsub("Rcpp::","",type.arg)
  type.arg <-gsub("arma::","",type.arg)
  st_val <- paste0("= ","RcppDeepState_",(type.arg),"()",";\n")
  inputs_path <- file.path(fun_path,"inputs")
  if(!dir.exists(inputs_path)){
    dir.create(inputs_path)
  }
  if(type.arg == "mat"){
    write_to_file<-paste0(write_to_file,indent,"std::ofstream ",
                          gsub(" ","",arg.name),"_stream",";\n")
    input.vals <- file.path(inputs_path,arg.name)
    file_open <- gsub("# ","\"",paste0(arg.name,"_stream.open(#",input.vals,"# );","\n",indent,
                                       arg.name,"_stream << ", 
                                       arg.name,";","\n",indent,
                                       "std::cout << ","#",arg.name,
                                       " values: ","#"," << ",arg.name,
                                       " << std::endl;","\n",indent,
                                       arg.name,"_stream.close();","\n"))
  }
  else{
    if(type.arg == "int"){
      variable <- paste0("IntegerVector ",arg.name,"(1)","\n",indent,arg.name,"[0]")
    }
    if(type.arg == "double") {
      variable <- paste0("NumericVector ",arg.name,"(1)","\n",indent,arg.name,"[0]")
    }
    if(type.arg == "std::string")
    {
      variable <- paste0("CharacterVector ",arg.name,"(1)","\n",indent,arg.name,"[0]")
    }
    arg.file <- paste0(arg.name,".qs")
    input.vals <- file.path(inputs_path,arg.file)
    file_open <- gsub("# ","\"",paste0("qs::c_qsave(",arg.name,",#",input.vals,"#,\n","\t\t#high#, #zstd#, 1, 15, true, 1);\n",indent,
                                       "std::cout << ","#",arg.name," values: ","#"," << ",arg.name,
                                       " << std::endl;","\n"))
  }
  proto_args <- gsub(" ","",paste0(proto_args,arg.name))
  if(argument.i < nrow(functions.rows)) proto_args <- paste0(proto_args,",")
  write_to_file <- paste0(write_to_file,indent,paste0(variable,indent,st_val,indent,file_open))
}
write_to_file<-paste0(write_to_file,indent,"std::cout << #input ends# << std::endl;\n",indent,"try{\n")
if(type.arg == "int" || type.arg == "double" || type.arg == "std::string"){
  write_to_file<-paste0(write_to_file,indent,indent,fun_name,"(",proto_args,"[0]);\n")  
}else{
  write_to_file<-paste0(write_to_file,indent,indent,fun_name,"(",proto_args,"[0]);\n")
}
write_to_file<-gsub("#","\"",paste0(write_to_file,indent,"}\n",indent,"catch(Rcpp::exception& e){\n",indent,indent,"std::cout<<#Exception Handled#<<std::endl;\n",indent,"}"))
write_to_file<-paste0(write_to_file,"\n","}")
write(write_to_file,file_path,append=TRUE)
file.var <- file_path

}