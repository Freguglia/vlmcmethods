// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// contextAlgorithm
Rcpp::List contextAlgorithm(List data, unsigned int Hmax, unsigned int alphlen, double cutoff);
RcppExport SEXP _vlmcmethods_contextAlgorithm(SEXP dataSEXP, SEXP HmaxSEXP, SEXP alphlenSEXP, SEXP cutoffSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< List >::type data(dataSEXP);
    Rcpp::traits::input_parameter< unsigned int >::type Hmax(HmaxSEXP);
    Rcpp::traits::input_parameter< unsigned int >::type alphlen(alphlenSEXP);
    Rcpp::traits::input_parameter< double >::type cutoff(cutoffSEXP);
    rcpp_result_gen = Rcpp::wrap(contextAlgorithm(data, Hmax, alphlen, cutoff));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_vlmcmethods_contextAlgorithm", (DL_FUNC) &_vlmcmethods_contextAlgorithm, 4},
    {NULL, NULL, 0}
};

RcppExport void R_init_vlmcmethods(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
