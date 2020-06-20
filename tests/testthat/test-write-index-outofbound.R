library(testthat)
context("rcpp_write_index_outofbound")
library(RcppDeepState)

log_path <- system.file("include/write_index_outofbound_log", package = "RcppDeepState")
print(log_path)
user.display <- user_error_display(log_path)
test_that("valgrind writing index out of bound", {
  expect_match(user.display$arg.name,"boundvalue")
  #expect_match(user.display$src.file.lines,"write_index_outofbound.cpp")
  #expect_match(user.display$error.message[1],"Invalid read of size 4")
})
