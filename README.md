# RcppDeepState <a href="http://r-datatable.com"><img src="https://github.com/akhikolla/RcppDeepState/tree/master/inst/graphics/logo.jpg" align="right" height="140" /></a>

/home/akhila/R/RcppDeepState/inst/graphics/logo.jpg

[![Build Status](https://travis-ci.org/akhikolla/RcppDeepState.svg?branch=master)](https://travis-ci.org/akhikolla/RcppDeepState)

RcppDeepState, a simple way to fuzz test compiled code in Rcpp packages. This package extends the DeepState framework to fully support Rcpp based packages.

**Note:** RcppDeepState is currently supported on Linux and macOS, with windows support in progress.

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

(a)**deepstate_pkg_create**: This function creates the TestHarnesses for all the functions in the test package with the corresponding makefiles.

This is the first function we need to make a call to create the testharness, create a deepstate library, and install the test package.

```R
> library(RcppDeepState)
> RcppDeepState::deepstate_pkg_create("~/R/RcppDeepState/inst/testpkgs/testSAN")
Testharness created for 6 functions in the package
 [1] "success"
```
All these files generated are stored in inst/test files in your test package.

(b) **deepstate_harness_compile_run**: This function compiles and runs all the TestHarnesses that are created above and test your code for errors/bugs and stores the results in logfiles.

```R
RcppDeepState::deepstate_harness_compile_run("~/R/RcppDeepState/inst/testpkgs/testSAN")

```
If all the function in the package are successfully compiled it gives the following message:

```R
>[1] "Compiled all the functions in the package successfully"
```

(c) **deepstate_harness_analyze_one**: This function analyzes each binary crash/fail file generated and provides a log of error messages if there are any and also displays the inputs passed on to the function to generate the crash.
This function lists out the error messages, line numbers where the error occurred, and inputs that are passed on to the functions taking the log files as input. The generated log files are stored in the respective crash file folder along with the inputs i.e inst/function/12abc.crash/valgrind_log

```R
RcppDeepState::deepstate_harness_analyze_one("~/R/RcppDeepState/inst/testpkgs/testSAN")
```

Example Output for function src/read_out_of_bound.cpp:

```R
Input parameter - rbound
Read 1 item
[1] 318916283
[[1]]
          kind                    msg                    errortrace
1: InvalidRead Invalid read of size 4 src/read_out_of_bound.cpp : 7
                  address trace
1: No address trace found    NA

[[2]]
                kind
1: Leak_PossiblyLost
                                                                               msg
1: 1,275,665,132 bytes in 1 blocks are possibly lost in loss record 1,279 of 1,279
                      errortrace                address trace
1: src/read_out_of_bound.cpp : 6 No address trace found    NA

```
Now RcppDeepState makes it easy to use RcppDeepState on Travis-CI. 

**deepstate_ci_setup**: This function edits your .travis.yml file or creates one if it doesn't exist with the necessary packages and environment variables and now push your updated code to GitHub and check the Travis build for the test package for results.

```R
RcppDeepState::deepstate_ci_setup(pathtotestpackage)
```
