library(testthat)
context("rcpp_use_after_deallocate")
library(RcppDeepState)


log_path <- system.file("include/use_after_deallocate_log", package = "RcppDeepState")
print(log_path)
user.display <- user_error_display(log_path)
test_that("valgrind use after deallocate errors", {
  expect_match(user.display$arg.name,"size")
  expect_match(user.display$src.file.lines,"use_after_deallocate.cpp")
  expect_match(user.display$error.message[1],"Invalid read of size 1")

})



test_that("negative size array", {
  expect_lt(as.numeric(user.display$value[3]),0)
  #expect_match(user.display$error.message[3],"function has a fishy value")
})


