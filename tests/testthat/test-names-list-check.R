library(testthat)
context("deepstate_analyze_one")
library(RcppDeepState)
path <- system.file("testpkgs/binsegRcpp", package = "RcppDeepState")
arguments.list <- deep_harness_analyze_one(path,"rcpp_binseg_normal",system.file("RcppDeepStatefiles/binsegRcpp/binseg_normal_output/dd5b1543eccdc54b284c00142df7f40c1583ac68.crash", package = "RcppDeepState"))                         
test_that("argumentlist names validation", {
  expect_identical(names(arguments.list), c("data_vec", "max_segments"))
})





