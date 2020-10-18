library(testthat)
context("deepstate_compile_run")
library(RcppDeepState)

library(testthat)
context("deepstate_compile_run")
library(RcppDeepState)

path <- system.file("testpkgs/testSAN", package = "RcppDeepState")
print(path)

funs.list <- c("rcpp_read_out_of_bound","rcpp_use_after_deallocate","rcpp_use_after_free",
               "rcpp_use_uninitialized","rcpp_write_index_outofbound","rcpp_zero_sized_array")

harness.vec <- paste0(funs.list,"_DeepState_TestHarness.cpp")
result<-deepstate_pkg_create(path)
test_that("create files testSAN package", {
  expect_identical(result,harness.vec)
})

funpath.list <- paste0(system.file("testpkgs/testSAN/inst/testfiles",
                                   package="RcppDeepState"),"/",funs.list)
harness.list <- paste0(funpath.list,"/",funs.list,"_DeepState_TestHarness.cpp")
makefile.list <- paste0(funpath.list,"/","Makefile")
test_that("harness files and makefiles exist for testSAN", {
  expect_true(all(file.exists(harness.list)))
  expect_true(all(file.exists(makefile.list)))
})


dhcr<-deepstate_harness_compile_run(path)
test_that("compile run after create pkg", {
  expect_identical(dhcr,as.character(funs.list))
})

print(Sys.getenv('TRAVIS'))
if(identical(Sys.getenv('TRAVIS'), 'true'))
{  max_inputs=1
}else{max_inputs="all"}
cat("Max_inputs",max_inputs)
deepstate_harness_analyze_pkg(path,max_inputs)

object.list <- paste0(funpath.list,"/",funs.list,"_DeepState_TestHarness.o")
test_that("object files existence", {
  expect_true(all(file.exists(object.list)))
})
executable.list <-paste0(funpath.list,"/",funs.list,"_DeepState_TestHarness")
test_that("executable files existence", {
  expect_true(all(file.exists(executable.list)))
})

inputfolder.list <- file.path(funpath.list,"inputs")
test_that("inputfolder files existence", {
  expect_true(all(dir.exists(inputfolder.list)))
})

functions.list <- deepstate_get_function_body(path)
args.list <- gsub(" ","",functions.list$argument.name)
path.args.list <- file.path(funpath.list,"inputs",paste0(args.list))
#print(path.args.list)
#print(file.exists(path.args.list))
test_that("input files existence", {
  expect_true(all(file.exists(path.args.list)))
})
outputfolder.list <- paste0(funpath.list,"/",funs.list,"_output")
test_that("outputfolder files existence", {
  expect_true(all(dir.exists(outputfolder.list)))
})


list.crashes <-Sys.glob(file.path(funpath.list,paste0(funs.list,"_output"),"*"))
log.result <- deepstate_analyze_file(list.crashes[1])
print(log.result)



