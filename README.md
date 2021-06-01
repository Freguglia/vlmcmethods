
<!-- README.md is generated from README.Rmd. Please edit that file -->

# vlmcmethods

<!-- badges: start -->
<!-- badges: end -->

Methods for Variable-Length Markov Chain models…

## Installation

Install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Freguglia/vlmcmethods")
```

## Example

``` r
library(vlmcmethods)
# Example dataset format
str(binchain)
#> List of 4
#>  $ 1: num [1:2500] 0 1 0 0 1 0 0 0 0 1 ...
#>  $ 2: num [1:2500] 0 1 0 1 0 1 0 1 1 1 ...
#>  $ 3: num [1:2500] 1 1 1 0 1 1 0 1 1 0 ...
#>  $ 4: num [1:2500] 1 1 1 1 1 1 0 1 1 1 ...

# Fitting VLMC via context algorithm
fit <- vlmcfit(binchain, Hmax = 8, cutoff = 10)
fit
#> Fitted tree: {r0,r10,r110,r1110,r11110,r111110,r1111110,r1111111} 
#> Maximum Log-Likelihood value for fitted tree:
#>  -6029.446
summary(fit)
#> Cutoff value:  10 
#> 
#> Maximum Log-Likelihood value for fitted tree:
#>  -6029.446 
#> 
#> Estimated probabilities:
#>    context         0         1    n         lrt
#> 1       r0 0.4936980 0.5063020 3729 0.219002759
#> 2      r10 0.1639344 0.8360656 1891 0.604912606
#> 3     r110 0.4987342 0.5012658 1580 0.180365635
#> 4    r1110 0.1666667 0.8333333  792 0.979038502
#> 5   r11110 0.4939394 0.5060606  660 0.417806174
#> 6  r111110 0.1651652 0.8348348  333 0.084933275
#> 7 r1111110 0.4964029 0.5035971  278 0.025904850
#> 8 r1111111 0.1971631 0.8028369  705 0.004428878

# Plotting trees
plot(fit)
```

<img src="man/figures/README-example-1.png" width="70%" />

``` r
# Obtain a tbl_graph object from the fitted tree (string)
graph <- tree_graph(fit)
graph
#> # A tbl_graph: 15 nodes and 14 edges
#> #
#> # A rooted tree
#> #
#> # Node Data: 15 x 7 (active)
#>   name    last  probs_chr `0`   `1`       n lrt  
#>   <chr>   <chr> <chr>     <chr> <chr> <int> <chr>
#> 1 r0      0     0.49 0.51 0.49  0.51   3729 0.22 
#> 2 r10     0     0.16 0.84 0.16  0.84   1891 0.60 
#> 3 r110    0     0.50 0.50 0.50  0.50   1580 0.18 
#> 4 r1110   0     0.17 0.83 0.17  0.83    792 0.98 
#> 5 r11110  0     0.49 0.51 0.49  0.51    660 0.42 
#> 6 r111110 0     0.17 0.83 0.17  0.83    333 0.08 
#> # … with 9 more rows
#> #
#> # Edge Data: 14 x 2
#>    from    to
#>   <int> <int>
#> 1     9     7
#> 2     9     8
#> 3    10     6
#> # … with 11 more rows
# You can use this object within the 'ggraph' package to create 
# custom visualizations
```
