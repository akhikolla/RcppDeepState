#include "binseg_normal_cost.h"
#include <math.h>
#include <iostream>
#include <map>
#include <vector>
#include <R.h>

double ocost(double s, int N){
  return -s*s/N;
}

class Segment {
public:
  int first, last, best_end;
  double best_decrease;
  Segment(){
  }
  double init(const double *data_vec, int first_, int last_){
    first = first_;
    last = last_;
    double sum_before = 0.0, sum_after = 0.0;
    double cost_before, cost_after, cost_split, data_value;
    for(int i=first; i <= last; i++){
      sum_after += data_vec[i];
    }
    double cost = ocost(sum_after, last-first+1);
    int end_i;
    int n_candidates = last-first;
    double best_cost = INFINITY;
    for(int ci=0; ci<n_candidates; ci++){
      end_i = first+ci;
      data_value = data_vec[end_i];
      sum_before += data_value;
      sum_after  -= data_value;
      cost_before = ocost(sum_before, ci+1);
      cost_after  = ocost(sum_after, n_candidates-ci);
      cost_split = cost_before + cost_after;
      if(cost_split < best_cost){
	best_cost = cost_split;
	best_end = end_i;
      }
    }
    best_decrease = best_cost - cost;
    return cost;
  }
};

class SegVec {
public:
  std::multimap<double,int> tree;
  std::vector<Segment> seg_vec;
  const double *data_vec;
  int next_i;
  SegVec(const double *data_vec_, int n_entries){
    data_vec = data_vec_;
    seg_vec.resize(n_entries);
    next_i = 0;
  }
  double add_segment(int first, int last){
    double cost = seg_vec[next_i].init(data_vec, first, last);
    if(first < last){
      tree.insert
	(std::pair<double,int>(seg_vec[next_i].best_decrease, next_i));
    }
    next_i++;
    return cost;
  }
};

int binseg_normal_cost
(const double *data_vec, int n_data,
 int max_segments, double *cost){
  SegVec V(data_vec, 2*max_segments+1);
  cost[0] = V.add_segment(0, n_data-1);
  int seg_i=1;
  std::multimap<double,int>::iterator it;
  while(seg_i < max_segments){
    it = V.tree.begin();
    Segment* s = &V.seg_vec[it->second];
    cost[seg_i] = cost[seg_i-1] + s->best_decrease;
    V.add_segment(s->first, s->best_end);
    V.add_segment(s->best_end+1, s->last);
    V.tree.erase(it);
    seg_i++;
  }
  return 0;
}

