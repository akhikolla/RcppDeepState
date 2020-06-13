library(testthat)
context("deepstate_compile_run")
library(RcppDeepState)

#dhc<-deep_harness_compile_run(here::here("./RcppDeepState/inst/include/testpkgs/binsegRcpp"))
dhc<-deep_harness_compile_run(system.file("testpkgs/binsegRcpp", package = "RcppDeepState"))
  #here::here("/home/travis/build/akhikolla/RcppDeepState/inst/include/testpkgs/binsegRcpp"))
test_that("compile and run check", {
  expect_match(dhc,"code compiled")
})
