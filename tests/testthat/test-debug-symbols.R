library(RcppDeepState)

testSAN_path <- system.file("testpkgs/testSAN", package = "RcppDeepState")


test_that("Check debug symbols", {
    
    # We choose seed=1000 since it has been demonstrated locally that 
    # RcppDeepState detects several issues when using this number.     
    deepstate_harness_compile_run(testSAN_path, seed=1000)
    result <- deepstate_harness_analyze_pkg(testSAN_path)
    
    
    # If debug symbols are included in the final binary, then the resulting 
    # table will contain some information. On the other hand, if the resulting 
    # table is empty, it means that the library is missing debug symbols.
    logtable_is_empty <- all(sapply(result$logtable, function(table) nrow(table) == 0))
    
    expect_false(logtable_is_empty)

})

