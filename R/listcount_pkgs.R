list.all.possible <- function(){
pkg.list.psbl <- list()
d.count = 0
for(package_name in pkg.list){
  functions.list <-  RcppDeepState::deepstate_get_function_body(package_name)
  if(!is.null(functions.list) && length(functions.list) > 1){
    functions.list$argument.type<-gsub("Rcpp::","",functions.list$argument.type)
    fun_names <- unique(functions.list$funName)
    for(function_name.i in fun_names){
      functions.rows  <- functions.list [functions.list$funName == function_name.i,]
      params <- c(functions.rows$argument.type)
      if( RcppDeepState::deepstate_datatype_check(params) == 1){
        cat(sprintf("package name %s\n",package_name))
        pkg.list.psbl[package_name][function_name.i] <- function_name.i 		
      }
      else { d.count = d.count + 1}
     
    }
    if(d.count == length(fun_names)){
      file.copy(package_name,"~/tpackages/fpackages",overwrite = TRUE, 
                recursive = TRUE, 
                copy.mode = TRUE)
      unlink(package_name, recursive = TRUE)
    }
  }
}
print(pkg.list.psbl)
}

Error_files_test <- function(){
  pkg.exec <- 0
  pkg.execlist <- list() 
  pkg.unexlist <- list()
  pkgs <- Sys.glob(file.path("/home/akolla/R/x86_64-pc-linux-gnu-library/3.6/RcppDeepState/extdata/compileAttributes","*"))
  for(pkg.i in pkgs){
    exelist <- list()
    unexelist <- list()
    print(pkg.i)
    testfiles <- file.path(pkg.i,"inst/testfiles")
    fun.count <- Sys.glob(file.path(testfiles,"*"))
    if(length(fun.count) > 0){
    for(fun.i in fun.count){
       harness <-file.path(fun.i,paste0(basename(fun.i),"_DeepState_TestHarness.cpp"))
       obj <- file.path(fun.i,paste0(basename(fun.i),"_DeepState_TestHarness.o"))
       exec <-file.path(fun.i,paste0(basename(fun.i),"_DeepState_TestHarness"))
       if(file.exists(harness) && file.exists(obj) && file.exists(exec)){
         pkg.exec <- pkg.exec + 1
         exelist<- c(exelist,basename(fun.i))
       }
       else{
         unexelist<-c(unexelist,basename(fun.i))
       }
    }
      pkg.execlist[[basename(pkg.i)]] <-exelist
      pkg.unexlist[[basename(pkg.i)]] <-unexelist
    }
  }
  print("Done")
  print("Executed package:\n")
 print(pkg.execlist)
 print("Unexecuted package:\n")
 print(pkg.unexlist)
}

functions.list.check <- function(){
  test.files <- list()
  nons <- 0
  untestable <- Sys.glob(file.path("~/R/x86_64-pc-linux-gnu-library/3.6/RcppDeepState/extdata/untestable_pkgscheck","*"))
  cat(sprintf("untestable files -%d\n",length(untestable)))
  for(i in untestable){
  functions.list <-  RcppDeepState::deepstate_get_function_body(i)
  if(!is.null(functions.list) && length(functions.list) > 1){
    test.files[[basename(i)]] <- functions.list
  }else{
    nons = nons + 1
    cat(sprintf("no test functions returned - %s\n",basename(i)))
    #cat(sprintf("test files returned - %s\n",functions.list))
  }
 }
  print(test.files)
  cat(sprintf("test files not returned -%d\n",nons))
  cat(sprintf("test files returned -%d\n",length(test.files)))
}


total_counts <- function(){
pkgs <- Sys.glob(file.path("/home/akolla/R/x86_64-pc-linux-gnu-library/3.6/RcppDeepState/extdata/compileAttributes","*"))
tot.fun.count <- 0
pkg.exports <- 0
pkg.exlist <- list() 
non.test.list <- list()
non.test.total <- 0
pkg.lists <- list()
pkg.count <- 0
for(pkg.i in pkgs){
  fun.count <- 0
  testfiles <- file.path(pkg.i,"inst/testfiles")
  RcppExports.cpp <- file.path(pkg.i, "src", "RcppExports.cpp")
  fun.count <- Sys.glob(file.path(testfiles,"*"))
  if(length(fun.count) > 0){
  pkg.count = pkg.count + 1
  pkg.lists[[basename(pkg.i)]] = length(fun.count)
  tot.fun.count <- tot.fun.count + length(fun.count)
  }else {
    if(!file.exists(RcppExports.cpp)){
      pkg.exports = pkg.exports + 1
      pkg.exlist<- c(pkg.exlist,basename(pkg.i))
    }else{
    non.test.list <- c(non.test.list,basename(pkg.i)) 
    non.test.total <- non.test.total + 1
    }
  }
}
untestable <- Sys.glob(file.path("~/R/x86_64-pc-linux-gnu-library/3.6/RcppDeepState/extdata/untestable_pkgscheck","*"))
print(pkg.lists)
cat(sprintf("Total functions evaluated :\n%d\n", tot.fun.count))
cat(sprintf("Total packages evaluated : \n%d\n", pkg.count))
cat(sprintf("empty testfiles packages : \n%d\n",non.test.total))
cat(sprintf("empty testfiles packages : \n%s\n",list(non.test.list)))
cat(sprintf("length of untestable packages : \n%d\n",length(untestable)))
cat(sprintf("empty testfiles packages and untestable : \n%s\n",list(intersect(non.test.list,basename(untestable)))))
cat(sprintf("length of the files empty testfiles packages and untestable: \n%d\n",length(list(intersect(non.test.list,basename(untestable))))))
cat(sprintf("No Rcpp exports file for pkg - \n%s\n",list(pkg.exlist)))
cat(sprintf("Count No Rcpp exports file - \n%d\n",pkg.exports))

}

