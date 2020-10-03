library(testthat)
context("deepstate_compile_run")
library(RcppDeepState)

print(Sys.getenv('TRAVIS'))
val <- "${TRAVIS}"
print(val)
if(identical(Sys.getenv('TRAVIS'), 'true'))
max_inputs=1 else max_input="all"
print(max_inputs)
#deepstate_harness_analyze_pkg(path,max_inputs)
##deepstate_harness_analyze_one(path)
##deepstate_tests_fuzz(path)