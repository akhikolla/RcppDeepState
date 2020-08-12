##' @title  creates testharness for given functions in package
##' @export
deepstate_create_testpkgs_objects<-function(){
  deepstate_path <- system.file("testpkgs/testSAN",package="RcppDeepState")
  includes <- paste0("g++ -std=gnu++11 -I${R_HOME}/include -DNDEBUG -I. -I../inst/include/")
  libs<- paste0(" -I",system.file("include", package="Rcpp")," -I/usr/local/include")
  flags<-" -fpic  -g -O2  -c "
  print(paste0(includes,libs,flags,deepstate_path,"/src/RcppExports.cpp -o ", deepstate_path,"/src/RcppExports.o"))
  print(paste0(includes,libs,flags,deepstate_path,"/src/read_out_of_bound.cpp -o ", deepstate_path,"/src/read_out_of_bound.o"))
  print(paste0(includes,libs,flags,deepstate_path,"/src/use_after_deallocate.cpp -o ", deepstate_path,"/src/use_after_deallocate.o"))
  print(paste0(includes,libs,flags,deepstate_path,"/src/use_after_free.cpp -o ", deepstate_path,"/src/use_after_free.o"))
  print(paste0(includes,libs,flags,deepstate_path,"/src/write_index_outofbound.cpp -o ", deepstate_path,"/src/write_index_outofbound.o"))
  print(paste0(includes,libs,flags,deepstate_path,"/src/zero_sized_array.cpp -o ", deepstate_path,"/src/zero_sized_array.o"))
  
  system(paste0(includes,libs,flags,deepstate_path,"/src/RcppExports.cpp -o ", deepstate_path,"/src/RcppExports.o"))
  system(paste0(includes,libs,flags,deepstate_path,"/src/read_out_of_bound.cpp -o ", deepstate_path,"/src/read_out_of_bound.o"))
  system(paste0(includes,libs,flags,deepstate_path,"/src/use_after_deallocate.cpp -o ", deepstate_path,"/src/use_after_deallocate.o"))
  system(paste0(includes,libs,flags,deepstate_path,"/src/use_after_free.cpp -o ", deepstate_path,"/src/use_after_free.o"))
  system(paste0(includes,libs,flags,deepstate_path,"/src/write_index_outofbound.cpp -o ", deepstate_path,"/src/write_index_outofbound.o"))
  system(paste0(includes,libs,flags,deepstate_path,"/src/zero_sized_array.cpp -o ", deepstate_path,"/src/zero_sized_array.o"))
} 