#!/bin/bash

# Install RcppDeepState with its dependendcies
Rscript -e "install.packages(c('Rcpp', 'RcppArmadillo', 'RInside', 'data.table', 'qs', 'nc', 'xml2'), repos='http://cran.us.r-project.org')"
Rscript -e "install.packages('./', repos = NULL, type='source', verbose=TRUE)"

# Compile the TestSAN package
Rscript -e "RcppDeepState::deepstate_harness_compile_run('./inst/testpkgs/testSAN')"

# check if the compiled binaries contains debug symbols
debug_info=$(file ./inst/testpkgs/testSAN/src/read_out_of_bound.o | grep debug_info)
if [ -z "$debug_info" ] ; then
    echo "ERROR: The binaries are missing debug symbols."
    exit 1
fi

echo "Sucessfully compiled with debug symbols."
exit 0
