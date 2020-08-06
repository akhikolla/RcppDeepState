library(testthat)
context("deepstate_compile_run")
library(RcppDeepState)


print(system.file("include", package="RInside"))
print(system.file("include", package="Rcpp"))
insts_path <- system.file(package="RcppDeepState")
print(insts_path)
#deepstate_create_static_lib()
deepstate_create_testpkgs_objects()
deepstate_make_run()

path <- system.file("testpkgs/testSAN", package = "RcppDeepState")
print(path)
res<-deepstate_pkg_create(path)
test_that("create files testSAN package", {
  expect_identical(res,1)
})

files.list<-deepstate_harness_files(path)
test_that("check for harness files existence testSAN package", {
  expect_true(file.exists(files.list[[1]]))
  expect_identical(files.list[[1]],system.file("testpkgs/testSAN/inst/testfiles/read_out_of_bound_DeepState_TestHarness.cpp",package = "RcppDeepState"))
  expect_true(file.exists(files.list[[2]]))
  expect_identical(files.list[[2]],system.file("testpkgs/testSAN/inst/testfiles/use_after_deallocate_DeepState_TestHarness.cpp",package="RcppDeepState"))
  expect_true(file.exists(files.list[[3]]))
  expect_identical(files.list[[3]],system.file("testpkgs/testSAN/inst/testfiles/use_after_free_DeepState_TestHarness.cpp",package="RcppDeepState"))
  expect_true(file.exists(files.list[[4]]))
  expect_identical(files.list[[4]],system.file("testpkgs/testSAN/inst/testfiles/write_index_outofbound_DeepState_TestHarness.cpp",package="RcppDeepState"))
  expect_true(file.exists(files.list[[5]]))
  expect_identical(files.list[[5]],system.file("testpkgs/testSAN/inst/testfiles/zero_sized_array_DeepState_TestHarness.cpp",package="RcppDeepState"))
})


test_that("check for harness files existence testSAN package", {
  expect_true(file.exists(files.list[[6]]))
  expect_identical(files.list[[6]],system.file("testpkgs/testSAN/inst/testfiles/read_out_of_bound.Makefile",package = "RcppDeepState"))
  expect_true(file.exists(files.list[[7]]))
  expect_identical(files.list[[7]],system.file("testpkgs/testSAN/inst/testfiles/use_after_deallocate.Makefile",package="RcppDeepState"))
  expect_true(file.exists(files.list[[8]]))
  expect_identical(files.list[[8]],system.file("testpkgs/testSAN/inst/testfiles/use_after_free.Makefile",package="RcppDeepState"))
  expect_true(file.exists(files.list[[9]]))
  expect_identical(files.list[[9]],system.file("testpkgs/testSAN/inst/testfiles/write_index_outofbound.Makefile",package="RcppDeepState"))
  expect_true(file.exists(files.list[[10]]))
  expect_identical(files.list[[10]],system.file("testpkgs/testSAN/inst/testfiles/zero_sized_array.Makefile",package="RcppDeepState"))
})


path <- system.file("testpkgs/testSAN", package = "RcppDeepState")
dhc<-deepstate_harness_compile_run(path)
logfiles<-deepstate_list_log_files(path)
test_that("check for log files existence testSAN package", {
  expect_true(file.exists(logfiles[[1]]))
  expect_identical(logfiles[[1]],system.file("testpkgs/testSAN/inst/testfiles/read_out_of_bound_log",package = "RcppDeepState"))
  expect_true(file.exists(logfiles[[2]]))
  expect_identical(logfiles[[2]],system.file("testpkgs/testSAN/inst/testfiles/use_after_deallocate_log",package = "RcppDeepState"))
  expect_true(file.exists(logfiles[[3]]))
  expect_identical(logfiles[[3]],system.file("testpkgs/testSAN/inst/testfiles/use_after_free_log",package = "RcppDeepState"))
  expect_true(file.exists(logfiles[[4]]))
  expect_identical(logfiles[[4]],system.file("testpkgs/testSAN/inst/testfiles/write_index_outofbound_log",package = "RcppDeepState"))
  expect_true(file.exists(logfiles[[5]]))
  expect_identical(logfiles[[5]],system.file("testpkgs/testSAN/inst/testfiles/zero_sized_array_log",package = "RcppDeepState"))
})

log_path <- system.file("extdata/read_out_of_bound_log", package = "RcppDeepState")
user.display <- deepstate_user_error_display(log_path)
test_that("valgrind errors", {
  expect_match(user.display$arg.name,"sizeofarray")
  expect_match(user.display$src.file.lines,"read_out_of_bound.cpp:9")
  expect_match(user.display$error.message[1],"Invalid read of size 4")
  expect_match(user.display$error.message[2],"std::bad_array_new_length")
})


log_path <- system.file("extdata/use_after_deallocate_log", package = "RcppDeepState")
user.display <- deepstate_user_error_display(log_path)
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
user.display <- deepstate_user_error_display(log_path)
test_that("valgrind writing index out of bound", {
  expect_match(user.display$arg.name,"boundvalue")
  #expect_match(user.display$src.file.lines,"write_index_outofbound.cpp")
  #expect_match(user.display$error.message[1],"Invalid read of size 4")
})

log_path <- system.file("extdata/zero_sized_array_log", package = "RcppDeepState")
user.display <- deepstate_user_error_display(log_path)
test_that("valgrind writing index out of bound", {
  expect_match(user.display$arg.name,"vectorvalue")
  expect_match(user.display$src.file.lines,"zero_sized_array.cpp:11\nzero_sized_array.cpp:10\nzero_sized_array.cpp:12")
  expect_match(user.display$error.message[1],"Invalid write of size 4")
})


log_path <- system.file("extdata/use_after_free_log", package = "RcppDeepState")
user.display <- deepstate_user_error_display(log_path)
test_that("valgrind use after free check", {
  expect_match(user.display$arg.name,"size_free")
  expect_match(user.display$src.file.lines,"use_after_free.cpp")
  expect_match(user.display$error.message[1],"Invalid read of size 4")
})


bin_dir<- deepstate_list_bin_directory(path)
test_that("check for binary file directories existence testSAN package", {
  expect_true(dir.exists(bin_dir[[1]]))
  expect_identical(bin_dir[[1]],system.file("testpkgs/testSAN/inst/testfiles/read_out_of_bound_output",package = "RcppDeepState"))
  expect_true(dir.exists(bin_dir[[2]]))
  expect_identical(bin_dir[[2]],system.file("testpkgs/testSAN/inst/testfiles/use_after_deallocate_output",package = "RcppDeepState"))
  expect_true(dir.exists(bin_dir[[3]]))
  expect_identical(bin_dir[[3]],system.file("testpkgs/testSAN/inst/testfiles/use_after_free_output",package = "RcppDeepState"))
  expect_true(dir.exists(bin_dir[[4]]))
  expect_identical(bin_dir[[4]],system.file("testpkgs/testSAN/inst/testfiles/write_index_outofbound_output",package = "RcppDeepState"))
  expect_true(dir.exists(bin_dir[[5]]))
  expect_identical(bin_dir[[5]],system.file("testpkgs/testSAN/inst/testfiles/zero_sized_array_output",package = "RcppDeepState"))
  expect_true(all(file.exists(Sys.glob(file.path(bin_dir[[1]], "*.fail")))))
  expect_true(all(file.exists(Sys.glob(file.path(bin_dir[[2]], "*.fail")))))
  expect_true(all(file.exists(Sys.glob(file.path(bin_dir[[3]], "*.fail")))))
  expect_true(all(file.exists(Sys.glob(file.path(bin_dir[[4]], "*.fail")))))
  expect_true(all(file.exists(Sys.glob(file.path(bin_dir[[5]], "*.fail")))))
})
