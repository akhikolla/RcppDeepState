# RcppDeepState <a href="https://akhikolla.github.io./"><img src="https://github.com/akhikolla/RcppDeepState/blob/master/inst/graphics/logo.jpg" align="right" height="140" /></a>

[![Build Status](https://travis-ci.org/akhikolla/RcppDeepState.svg?branch=master)](https://travis-ci.org/akhikolla/RcppDeepState)

RcppDeepState, a simple way to fuzz test compiled code in Rcpp packages. This package extends the DeepState framework to fully support Rcpp based packages.

**Note:** RcppDeepState is currently supported on Linux and macOS, with windows support in progress.

## See Also

The [RcppDeepState blog](https://akhikolla.github.io./) to know more about the working of RcppDeepState. 

## Dependencies

First, make sure to install the following dependencies on your local machine.

* CMake
* GCC and G++ with multilib support
* Python 3.6 (or newer)
* Setuptools

Use this command line to install the dependencies.

```shell
sudo apt-get install build-essential gcc-multilib g++-multilib cmake python3-setuptools libffi-dev z3
```

## Installation

The RcppDeepState package can be installed from GitHub as follows:

```R
install.packages("devtools")

devtools::install_github("akhikolla/RcppDeepState")
```

## Functionalities

To test your package using RcppDeepState follow the steps below:

All these files generated are stored in inst/test files in your test package.

(a) **deepstate_harness_compile_run**: This function creates the TestHarnesses for all the functions in the test package with the corresponding makefiles. This function compiles and runs all those TestHarnesses that are created above and test your code for errors/bugs and stores the results in logfiles.

```R
RcppDeepState::deepstate_harness_compile_run("~/R/RcppDeepState/inst/testpkgs/testSAN")
```

It gives a list of functions that are successfully compiled in the package:

```R
>[1] "rcpp_read_out_of_bound"      "rcpp_use_after_deallocate" 
[3] "rcpp_use_after_free"         "rcpp_use_uninitialized"
[5] "rcpp_write_index_outofbound" "rcpp_zero_sized_array"
```

(b) **deepstate_harness_analyze_pkg**: This function analyzes each binary crash/fail file generated and provides a log of error messages if there are any and also displays the inputs passed on to the function to generate the crash.
This function lists out the error messages, line numbers where the error occurred, and inputs that are passed on to the functions taking the log files as input. The generated log files are stored in the respective crash file folder along with the inputs i.e inst/function/12abc.crash/valgrind_log

```R
result = RcppDeepState::deepstate_harness_analyze_pkg("~/R/RcppDeepState/inst/testpkgs/testSAN")
result
```

The result contains a data table with three columns: binary.file,inputs,logtable

```R
> head(rd,2)
                                                                                                                                                                                         binaryfile
1: /home/akolla/R/x86_64-pc-linux-gnu-library/3.6/RcppDeepState/testpkgs/testSAN/inst/testfiles/rcpp_read_out_of_bound/rcpp_read_out_of_bound_output/0001957a365ef90344a992e32cc2d49d4aedf572.crash
2: /home/akolla/R/x86_64-pc-linux-gnu-library/3.6/RcppDeepState/testpkgs/testSAN/inst/testfiles/rcpp_read_out_of_bound/rcpp_read_out_of_bound_output/0001b796162c8cd4b00f4b7ccf165b55b566cfce.crash
      inputs          logtable
1: <list[1]> <data.table[2x5]>
2: <list[1]> <data.table[1x5]>
> 


```
The inputs column contains all the inputs that are passed: 

```R
> head(rd$inputs,2)
[[1]]
[[1]]$rbound
[1] 437585945


[[2]]
[[2]]$rbound
[1] -519122509

```
The logtable has the data table with a list of errors:

```R
> head(rd$logtable,2)
[[1]]
             problem
1:       InvalidRead
2: Leak_PossiblyLost
                                                                           message
1:                                                          Invalid read of size 4
2: 1,750,343,780 bytes in 1 blocks are possibly lost in loss record 1,279 of 1,279
                       file.line
1: src/read_out_of_bound.cpp : 7
2: src/read_out_of_bound.cpp : 6
                                                                                        address.msg
1: Address 0xc21df234 is 1,750,344,180 bytes inside a block of size 1,750,347,680 in arena "client"
2:                                                                                 No Address found
            address.trace
1: No Address Trace found
2: No Address Trace found

[[2]]
      problem
1: FishyValue
                                                                                     message
1: Argument 'size' of function __builtin_vec_new has a fishy (possibly negative) value: -1\n
                       file.line      address.msg          address.trace
1: src/read_out_of_bound.cpp : 6 No Address found No Address Trace found
	
```

Before testing your package using RcppDeepState, we need to make sure that RcppDeepState is working correctly. To do so please make sure to check if RcppDeepState::compile_run_analyze() produces the same results as expected. 

For example, when we run the function rcpp_write_index_outofbound:

```R
fun_path <- file.path(path,"inst/testfiles/rcpp_write_index_outofbound") 
seed_analyze<-rcppdeepstate_compile_run_analyze(fun_path,1603403708,5)
print(seed_analyze)

```

Expected results: 

```R
problem                 message                      file.line

1: InvalidWrite Invalid write of size 4 write_index_outofbound.cpp : 8

                                                        address.msg

1: Address 0x2f63709c is not stack'd, malloc'd or (recently) free'd

            address.trace

1: No Address Trace found
```

Note : Make a call to deepstate_harness_compile_run(path) before calling rcppdeepstate_compile_run_analyze()

Now RcppDeepState makes it easy to use RcppDeepState on Travis-CI. 

**deepstate_ci_setup**: This function edits your .travis.yml file or creates one if it doesn't exist with the necessary packages and environment variables and now push your updated code to GitHub and check the Travis build for the test package for results.

```R
RcppDeepState::deepstate_ci_setup(pathtotestpackage)
```


