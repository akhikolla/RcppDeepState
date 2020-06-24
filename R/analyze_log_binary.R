##' @title  analyze the binary file 
##' @param path to test
##' @export
deep_harness_log_binary <- function(path){
  list.paths <-nc::capture_first_vec(path, "/",root=".+?","/",remain_path=".*")
  path_details <- nc::capture_all_str(list.paths$remain_path,val=".+/",folder=".+/",package_name=".+/",fun.name=".+/",binary_file=".*")
  exec.path <- paste0("/",list.paths$root,"/",path_details$val,path_details$folder,path_details$package_name," ;")
  fun <- gsub("_output/","",path_details$fun.name)
  exec <- paste0("./",fun,"_DeepState_TestHarness")
  binary_file<-paste0("/",list.paths$root,"/",path_details$val,path_details$folder,path_details$package_name,path_details$fun.name,path_details$binary_file)
  output_folder<-paste0("/",list.paths$root,"/",path_details$val,path_details$folder,path_details$package_name,path_details$fun.name,"log_",sub('\\..*', '', path_details$binary_file))
  dir.create(output_folder,showWarnings = FALSE)
  analyze_one <- paste0("valgrind --tool=memcheck --leak-check=yes ",exec," --input_test_file ",binary_file,"> ",output_folder,"/valgrind_log"," 2>&1")
  file.copy(path,output_folder)
  file.remove(path)
  var <- paste("cd",exec.path,analyze_one) 
  print(var)
  system(var)
}