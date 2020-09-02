library(testthat)
context("deepstate_compile_run")
library(RcppDeepState)

path <- system.file("testpkgs/testSAN", package = "RcppDeepState")
print(path)

funs.list <- c("rcpp_read_out_of_bound","rcpp_use_after_deallocate","rcpp_use_after_free",
               "rcpp_write_index_outofbound","rcpp_zero_sized_array")
dhcr<-deepstate_harness_compile_run(path)
test_that("compile run before create pkg", {
  expect_identical(dhcr,paste0("Issue compiling the function - ", funs.list))
})

res<-deepstate_pkg_create(path)
test_that("create files testSAN package", {
  expect_identical(res,"success")
})


funs.list <- c("rcpp_read_out_of_bound","rcpp_use_after_deallocate","rcpp_use_after_free",
               "rcpp_write_index_outofbound","rcpp_zero_sized_array")
funpath.list <- paste0(system.file("testpkgs/testSAN/inst/testfiles",
                                package="RcppDeepState"),"/",funs.list)
harness.list <- paste0(funpath.list,"/",funs.list,"_DeepState_TestHarness.cpp")
makefile.list <- paste0(funpath.list,"/","Makefile")
test_that("harness files and makefiles exist for testSAN", {
  expect_true(all(file.exists(harness.list)))
  expect_true(all(file.exists(makefile.list)))
})



dhcr<-deepstate_harness_compile_run(path)

object.list <- paste0(funpath.list,"/",funs.list,"_DeepState_TestHarness.o")
test_that("object files existence", {
  expect_true(all(file.exists(object.list)))
})
executable.list <-paste0(funpath.list,"/",funs.list,"_DeepState_TestHarness")
test_that("executable files existence", {
  expect_true(all(file.exists(executable.list)))
})
logfile.list <- paste0(funpath.list,"/",funs.list,"_log")
test_that("logfile files existence", {
  expect_true(all(file.exists(logfile.list)))
})
inputfolder.list <- file.path(funpath.list,"inputs")
test_that("inputfolder files existence", {
  expect_true(all(dir.exists(inputfolder.list)))
})
functions.list <- deepstate_get_function_body(path)
args.list <- gsub(" ","",functions.list$argument.name)
path.args.list <- file.path(funpath.list,"inputs",args.list)
test_that("input files existence", {
  expect_true(all(file.exists(path.args.list)))
})
outputfolder.list <- paste0(funpath.list,"/",funs.list,"_output")
test_that("outputfolder files existence", {
  expect_true(all(dir.exists(outputfolder.list)))
})


#deepstate_tests_fuzz(path)
log_path <- system.file("extdata/read_out_of_bound_log", package = "RcppDeepState")
print(log_path)
user.display <- user_error_display(log_path)
test_that("valgrind errors", {
  expect_match(user.display$arg.name,"sizeofarray")
  expect_match(user.display$src.file.lines,"read_out_of_bound.cpp:9")
  expect_match(user.display$error.message[1],"Invalid read of size 4")
  expect_match(user.display$error.message[2],"std::bad_array_new_length")
})


log_path <- system.file("extdata/use_after_deallocate_log", package = "RcppDeepState")
user.display <- user_error_display(log_path)
test_that("valgrind use after deallocate errors", {
  expect_match(user.display$arg.name,"size")
  expect_match(user.display$src.file.lines,"use_after_deallocate.cpp:7\nuse_after_deallocate.cpp:6\nuse_after_deallocate.cpp:5")
  expect_match(user.display$error.message[1],"Invalid read of size 1")
  
})

test_that("negative size array", {
  expect_lt(as.numeric(user.display$value[3]),0)
  #expect_match(user.display$error.message[3],"Argument 'size' of function __builtin_vec_new has a function has a fishy value")
})
log_path <- system.file("extdata/write_index_outofbound_log", package = "RcppDeepState")
user.display <- user_error_display(log_path)
test_that("valgrind writing index out of bound", {
  expect_match(user.display$arg.name,"boundvalue")
  #expect_match(user.display$src.file.lines,"write_index_outofbound.cpp")
  #expect_match(user.display$error.message[1],"Invalid read of size 4")
})

log_path <- system.file("extdata/zero_sized_array_log", package = "RcppDeepState")
user.display <- user_error_display(log_path)
test_that("valgrind writing index out of bound", {
  expect_match(user.display$arg.name,"vectorvalue")
  expect_match(user.display$src.file.lines,"zero_sized_array.cpp:11\nzero_sized_array.cpp:10\nzero_sized_array.cpp:12")
  expect_match(user.display$error.message[1],"Invalid write of size 4")
})


log_path <- system.file("extdata/use_after_free_log", package = "RcppDeepState")
user.display <- user_error_display(log_path)
test_that("valgrind use after free check", {
  expect_match(user.display$arg.name,"size_free")
  expect_match(user.display$src.file.lines,"use_after_free.cpp")
  expect_match(user.display$error.message[1],"Invalid read of size 4")
})


