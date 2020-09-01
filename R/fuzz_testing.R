##' @title deepstate_tests_fuzz
##' @param package_path path to the package to test
##' @author Akhila Chowdary Kolla
##' @export
deepstate_tests_fuzz <- function(package_path){
  #create test harness for the package
  deepstate_pkg_create(package_path)
  #compiles and runs the test harness
  deepstate_harness_compile_run(package_path)
  #read each binary file and generates log of the errors
  deepstate_harness_analyze_one(package_path)
}