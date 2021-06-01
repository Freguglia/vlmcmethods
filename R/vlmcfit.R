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
    
    out <- contextAlgorithm(z, Hmax, alphlen = m, cutoff)
    leaves <- str_remove_all(out$tree, "[\\{\\}]")
    leaves <- unlist(str_split(leaves, ","))
    names(out$probs) <- leaves
    
    out$probs <- t(dplyr::bind_rows(out$probs))
    out$probs <- cbind(rownames(out$probs),
                       data.frame(out$probs, row.names=NULL))
    colnames(out$probs) <- c("context", 0:(m-1))
    out$probs$n <- out$ns
    out$probs$lrt <- out$lrt
    
    out$cutoff <- cutoff
    out$data <- z
    
    class(out) <- "vlmcfit"
    return(out)
}

#' @export
print.vlmcfit <- function(x){
    cat("Fitted tree:", x$tree, "\n")
    cat("Maximum Log-Likelihood value for fitted tree:\n", x$ll, "\n")
    return(invisible(x))
}

#' @export
summary.vlmcfit <- function(x){
    cat("Cutoff value: ", x$cutoff, "\n\n")
    cat("Maximum Log-Likelihood value for fitted tree:\n", x$ll, "\n\n")
    cat("Estimated probabilities:\n")
    print(x$probs)
    return(invisible(x))
}