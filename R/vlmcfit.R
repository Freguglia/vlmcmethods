#' @name vlmcfit
#' @title Context Algorithm for fitting VLMC trees
#' @author Victor Freguglia
#' 
#' @param z Either an integer vector with the observed sequence
#'  or a list of integer vectors for multiple independent sequences.
#' @param Hmax Maximum range of the Markov Chain considered. 
#' Defaults to 8.
#' @param cutoff Cutoff value used in the Likelihood Ratio Test for
#' prunning.
#' @export
vlmcfit <- function(z, Hmax = 8, cutoff = NULL){
    if(Hmax > 15){stop("High values of 'Hmax' may exceed the available memory.")}
    if(!is.list(z)){
        z <- list(z)
    }
    m <- length(unique(unlist(z)))
    if(is.null(cutoff)){
        n <- length(unlist(z)) - Hmax*length(z)
        cutoff <- log(n)
    }
    
    contextAlgorithm(z, Hmax, alphlen = m, cutoff)
}