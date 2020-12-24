library(testthat)
context("deepstate_compile_run")
library(RcppDeepState)

rcppdeepstate.path <- system.file(package="RcppDeepState")
expect_error(deepstate_pkg_create(rcppdeepstate.path),"pkgdir must refer to the directory containing an R package")

path <- system.file("testpkgs/testSAN", package = "RcppDeepState")

funs.list <- c("rcpp_read_out_of_bound","rcpp_use_after_deallocate","rcpp_use_after_free",
               "rcpp_use_uninitialized","rcpp_write_index_outofbound","rcpp_zero_sized_array")

test_that("Missing testfiles", {
  expect_error(deepstate_fuzz_fun(path,"rcpp_read_out_of_bound"),"Missing testfiles directory")
})

write_bound <- deepstate_fun_create(path,"rcpp_write_index_outofbound")
harness.vec <- paste0("rcpp_write_index_outofbound_DeepState_TestHarness.cpp")
test_that("write index outofbound", {
  expect_identical(write_bound,harness.vec)
})

test_that("failed fuzz harnesss", {
  expect_error(RcppDeepState::deepstate_fuzz_fun(path,"rcpp_read_out_of_bound"),"TestHarness and makefile doesn't exists. Please use deepstate_pkg_create() to create them")
})

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

fun_name <- "rcpp_read_out_of_bound"
compiled.harness.timer <- RcppDeepState::deepstate_fuzz_fun(path,fun_name,time.limit.seconds=3)
print(compiled.harness.timer)
test_that("fuzz fun", {
  expect_identical(compiled.harness.timer,fun_name)
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
path.args.list <- file.path(funpath.list,"inputs",paste0(args.list,".qs"))
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
result.data.table <- log.result$logtable[[1]]
print(result.data.table)
.f = function() {
test_that("No valgrind issues", {
  expect_equal(nrow(result.data.table),0)
})
}

#fun_path <- file.path(path,"inst/testfiles/rcpp_use_uninitialized") 
#seed_analyze<-deepstate_fuzz_fun_seed(fun_path,1603839428,5)
#print(seed_analyze)

#.f = function() {
fun_wob <- file.path(path,"inst/testfiles/rcpp_write_index_outofbound") 
seed_table_wob<-deepstate_fuzz_fun_analyze(fun_wob,1603403708,6)
seed_analyze_wob <- seed_table_wob$logtable[[1]]
print("write out of bound")
print(seed_analyze_wob)
.f = function() {
test_that("seed output check", {
  expect_identical(seed_analyze_wob$err.kind,"InvalidWrite")
  expect_identical(seed_analyze_wob$message,"Invalid write of size 4")
  expect_identical(gsub("src/","",seed_analyze_wob$file.line),"write_index_outofbound.cpp : 8")
})
}

fun_uu <- file.path(path,"inst/testfiles/rcpp_use_uninitialized") 
seed_table_uu<-deepstate_fuzz_fun_analyze(fun_uu,1603839428,6)
seed_analyze_uu <- seed_table_uu$logtable[[1]]
print("uninitialized")
print(seed_analyze_uu)

.f = function() {
test_that("seed output check", {
  expect_identical(seed_analyze_uu$err.kind,"UninitCondition")
  expect_identical(seed_analyze_uu$message,"Conditional jump or move depends on uninitialised value(s)")
  expect_identical(gsub("src/","",seed_analyze_uu$file.line),"use_uninitalized.cpp : 7")
  expect_identical(gsub("src/","",seed_analyze_uu$address.trace),"use_uninitalized.cpp : 5")
  expect_identical(seed_analyze_uu$address.msg,"Uninitialised value was created by a stack allocation")
})
}
