#include "vlmcmethods.h"

// [[Rcpp::export]]
Rcpp::List contextAlgorithm(List data, unsigned int Hmax, unsigned int alphlen, double cutoff = 10.0){
  // Allocate maximal tree
  vlmcTree* tau = new vlmcTree(alphlen, Hmax);
  tau->root->tested = true;

  // Add data
  for(unsigned int i = 0; i<data.size(); i++){
        IntegerVector z = as<IntegerVector>(data[i]);
        bool is_first = i==0;
        tau->addData(z, is_first);
  }
  tau->cacheLikelihood();

  // Run tests
  vlmcNode* refLeaf;
  vector<vlmcNode*> uncheckedLeaves = tau->getUncheckedLeaves();
  while(uncheckedLeaves.size() > 0){
    uncheckedLeaves = tau->getUncheckedLeaves();
    refLeaf = uncheckedLeaves[0];
    double parent_ll = refLeaf->parent->llcache;
    double children_ll = 0;
    vector<vlmcNode*> sibs = refLeaf->getSiblings();
    for(vlmcNode* sib : sibs){
      children_ll += sib->llcache;
    }
    double llr = children_ll - parent_ll;
    if(llr < cutoff){ //prune test
      tau->pruneLeaf(refLeaf);
    } else {
      vector<vlmcNode*> siblings = refLeaf->getSiblings();
      for(unsigned int i=0; i<siblings.size(); i++){
        siblings[i]->tested = true;
      }
    }
    uncheckedLeaves = tau->getUncheckedLeaves();
  }
  
  // Return output
  string out = tau->concatLeaves();
  vector<vector<double>> probs;
  vector<unsigned int> ns;
  vector<vlmcNode*> final_leaves = tau->getVlmcLeaves();
  vector<double> lrtStats;
  double ll = 0;
  for(vlmcNode* leaf : final_leaves){
    probs.push_back(leaf->getProbs());
    ns.push_back(leaf->getN());
    ll += leaf->llcache;
    leaf->computeLrtStat();
    lrtStats.push_back(leaf->lrtStat);
  }
  delete tau;
  return Rcpp::List::create(
    Rcpp::Named("tree") = out,
    Rcpp::Named("probs") = probs,
    Rcpp::Named("ns") = ns,
    Rcpp::Named("lrtStats") = lrtStats,
    Rcpp::Named("ll") = ll);
}
