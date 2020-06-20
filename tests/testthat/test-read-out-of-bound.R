library(testthat)
library(data.table)
context("rcpp_read_out_of_bound")
library(RcppDeepState)

log_path <- system.file("include/read_out_of_bound_log", package = "RcppDeepState")
print(log_path)
user.display <- user_error_display(log_path)
test_that("valgrind errors", {
  expect_match(user.display$arg.name,"sizeofarray")
  expect_match(user.display$src.file.lines,"read_out_of_bound.cpp")
  expect_match(user.display$error.message[1],"Invalid read of size 4")
  expect_match(user.display$error.message[2],"std::bad_array_new_length")
  })

