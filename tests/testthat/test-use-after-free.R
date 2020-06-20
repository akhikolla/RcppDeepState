library(testthat)
context("rcpp_use_after_free")
library(RcppDeepState)

log_path <- system.file("include/use_after_free_log", package = "RcppDeepState")
print(log_path)
user.display <- user_error_display(log_path)
test_that("valgrind use after free check", {
  expect_match(user.display$arg.name,"size_free")
  expect_match(user.display$src.file.lines,"use_after_free.cpp")
  expect_match(user.display$error.message[1],"Invalid read of size 4")
})

