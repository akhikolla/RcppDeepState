#include "binseg_normal.h"
#include <math.h>
#include <map>
#include <vector>
#include <R.h>

double optimal_cost(double s, int N){
  return -s*s/N;
}

class Segment {
public:
  int first, last, best_end, invalidates_after, invalidates_index;
  double cost, mean;
  double best_mean_before, best_mean_after;
  double best_cost, best_decrease;
  Segment(){
  }
  void init(const double *data_vec, int first_, int last_, int invalidates_after_, int invalidates_index_){
    invalidates_after = invalidates_after_;
    invalidates_index = invalidates_index_;
    first = first_;
    last = last_;
    double sum_before = 0.0, sum_after = 0.0;
    double cost_before, cost_after, cost_split, data_value;
    for(int i=first; i <= last; i++){
      sum_after += data_vec[i];
    }
    int n_total = last-first+1;
    mean = sum_after/n_total;
    cost = optimal_cost(sum_after, n_total);
    int n_before, n_after, end_i;
    int n_candidates = last-first;
    best_cost = INFINITY;
    for(int ci=0; ci<n_candidates; ci++){
      end_i = first+ci;
      data_value = data_vec[end_i];
      sum_before += data_value;
      sum_after  -= data_value;
      n_before = ci+1;
      n_after = n_candidates-ci;
      cost_before = optimal_cost(sum_before, n_before);
      cost_after  = optimal_cost(sum_after, n_after);
      cost_split = cost_before + cost_after;
      if(cost_split < best_cost){
	best_cost = cost_split;
	best_mean_before = sum_before/n_before;
	best_mean_after = sum_after/n_after;
	best_end = end_i;
      }
    }
    best_decrease = best_cost - cost;
  }
};

class VectorTooSmall : public std::exception {
  const char * what() const throw(){
    return "Can NOT add segment because vector not large enough";
  }
};

class SegVec {
public:
  std::multimap<double,int> tree;
  std::vector<Segment> seg_vec;
  const double *data_vec;
  unsigned int next_i;
  SegVec(const double *data_vec_, int n_entries){
    data_vec = data_vec_;
    seg_vec.resize(n_entries);
    next_i = 0;
  }
  void add_segment(int first, int last, int invalidates_after, int invalidates_index){
    if(next_i < seg_vec.size()){
      seg_vec[next_i].init(data_vec, first, last, invalidates_after, invalidates_index);
      if(first < last){
	tree.insert
	  (std::pair<double,int>(seg_vec[next_i].best_decrease, next_i));
      }
      next_i++;
    }else{
      throw VectorTooSmall();
    }
  }
};

int binseg_normal
(const double *data_vec, const int n_data, const int max_segments,
 int *seg_end, double *cost,
 double *before_mean, double *after_mean, 
 int *before_size, int *after_size, 
 int *invalidates_index, int *invalidates_after){
  if(n_data < 1){
    return ERROR_NO_DATA;
  }
  if(max_segments < 1){
    return ERROR_NO_SEGMENTS;
  }
  if(n_data < max_segments){
    return ERROR_TOO_MANY_SEGMENTS;
  }
  SegVec V(data_vec, 2*max_segments+1);
  V.add_segment(0, n_data-1, 0, 0);
  seg_end[0] = n_data-1;
  cost[0] = V.seg_vec[0].cost;
  before_mean[0] = V.seg_vec[0].mean;
  after_mean[0] = INFINITY;
  before_size[0] = n_data;
  after_size[0] = -2;
  invalidates_index[0]=-2;
  invalidates_after[0]=-2;
  int seg_i=1;
  while(seg_i < max_segments){
    std::multimap<double,int>::iterator it = V.tree.begin();
    Segment* s = &V.seg_vec[it->second];
    seg_end[seg_i] = s->best_end;
    cost[seg_i] = cost[seg_i-1] + s->best_decrease;
    before_mean[seg_i] = s->best_mean_before;
    after_mean[seg_i] = s->best_mean_after;
    invalidates_index[seg_i]=s->invalidates_index;
    invalidates_after[seg_i]=s->invalidates_after;
    before_size[seg_i]=s->best_end - s->first + 1;
    after_size[seg_i]=s->last - s->best_end;
    V.add_segment(s->first, s->best_end, 0, seg_i);
    V.add_segment(s->best_end+1, s->last, 1, seg_i);
    V.tree.erase(it);
    seg_i++;
  }
  return 0;
}

