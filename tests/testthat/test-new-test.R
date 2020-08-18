library(testthat)
context("deepstate_compile_run")
library(RcppDeepState)

path <- system.file("testpkgs/testSAN", package = "RcppDeepState")
print(path)
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
args.list <- functions.list$argument.name
path.args.list <- file.path(funpath.list,"inputs",args.list)
test_that("input files existence", {
  expect_true(all(file.exists(path.args.list)))
})
outputfolder.list <- paste0(funpath.list,"/",funs.list,"_output")
test_that("outputfolder files existence", {
  expect_true(all(dir.exists(outputfolder.list)))
})



