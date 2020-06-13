library(testthat)
context("rcpp_zero_sized_array")
library(RcppDeepState)
library(data.table)

user.display <- user_error_display("zero_sized_array_log")
test_that("valgrind writing index out of bound", {
  expect_match(user.display$arg.name,"vectorvalue")
  expect_match(user.display$src.file.lines,"zero_sized_array.cpp")
  expect_match(user.display$error.message[1],"Invalid write of size 4")
})

