/* -*- compile-command: "R CMD INSTALL .." -*- */

#define ERROR_NO_DATA 1
#define ERROR_TOO_MANY_SEGMENTS 2
#define ERROR_NO_SEGMENTS 3

int binseg_normal
(const double *data_vec, const int n_data, const int max_segments,
 int *seg_end, double *cost,
 double *before_mean, double *after_mean,
 int *, int *,
 int *invalidates_index, int *invalidates_before);

