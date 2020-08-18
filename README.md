## RcppDeepState

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

(a) **make_run**: This function gets the latest deepstate build and makes a call to the respective cmake and make and generates a deepstate static library which is necessary to compile and run the testharness for the test package.

This is the first thing we need to do before creating the testharness.

```R
library(RcppDeepState)
RcppDeepState::deepstate_make_run()
```

(b) **deepstate_pkg_create**: This function creates the TestHarnesses for all the functions in the test package with the corresponding makefiles.

```R
RcppDeepState::deepstate_pkg_create(pathtotestpackage)
```
All these files generated are stored in inst/testfiles in your test package.

(c) **deep_harness_compile_run**: This function compiles and runs all the TestHarnesses that are created above and test your code for errors/bugs and stores the results in logfiles.

```R
RcppDeepState::deepstate_harness_compile_run(pathtotestpackage)
```

(d) **user_error_display**: This function lists out the error messages, line numbers where the error occurred, and inputs that are passed on to the functions taking the log files as input. The generated log files are stored in the same folder as testharness i.e inst/testfiles

```R
RcppDeepState::deepstate_user_error_display(testpackage/inst/testfiles/funname_log)
```
Now RcppDeepState makes it easy to use RcppDeepState on Travis-CI. 

**deepstate_ci_setup**: This function edits your .travis.yml file or creates one if it doesn't exist with the necessary packages and environment variables and now push your updated code to GitHub and check the Travis build for the test package for results.

```R
RcppDeepState::deepstate_ci_setup(pathtotestpackage)
```
