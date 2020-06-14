library(testthat)
context("deepstate_compile_run")
library(RcppDeepState)


path <- system.file("testpkgs/testSAN", package = "RcppDeepState")
print(path)
dhc<-deep_harness_compile_run(path)
#here::here("/home/travis/build/akhikolla/RcppDeepState/inst/include/testpkgs/binsegRcpp"))
test_that("compile and run check", {
  expect_match(dhc,"code compiled")
})



