#' @importFrom stringr str_remove_all str_split str_length str_trunc str_detect
#' @importFrom tidygraph tbl_graph
#' @importFrom tidyr unite
#' @importFrom dplyr left_join mutate_if
#' @export
tree_graph <- function(x){
    leaves <- x$tree
    leaves <- str_remove_all(leaves, "\\{")
    leaves <- str_remove_all(leaves, "\\}")
    leaves <- str_split(leaves, pattern = ",")
    leaves <- unlist(leaves)
    m <- ncol(x$probs) - 3
    H <- max(str_length(leaves))
    nodes <- leaves
    for(i in 1:(H-1)){
        nodes <- unique(c(nodes,
                          str_trunc(nodes, H-i,
                                    side = "right",
                                    ellipsis = "")))
    }
    dfnodes <- data.frame(name = nodes,
                          last = str_trunc(nodes, 1,
                                           side = "left",
                                           ellipsis = ""))
    dfnodes <- left_join(dfnodes, x$probs, by = c("name" = "context"))
    dfnodes$n <- as.character(dfnodes$n)
    dfnodes <- mutate_if(dfnodes, is.numeric, 
                         function(x) format(round(x,2), nsmall = 2))
    dfnodes <- unite(dfnodes, "probs_chr", (2+1):(2+m), sep = " ", remove = FALSE)
    dfnodes$n <- as.integer(dfnodes$n)
    dfedges <- data.frame(from = numeric(), to = numeric())
    
    for(i in seq_along(nodes)){
        this_len <- str_length(nodes[i])
        one_larger <- which((str_length(nodes) == (this_len + 1)) &
                                (str_detect(nodes, nodes[i])))
        if(length(one_larger) > 1){
            dfedges <- rbind(dfedges, 
                             data.frame(from = i, to = one_larger))
        }
    }
    return(dplyr::arrange(tbl_graph(nodes = dfnodes, edges = dfedges), last))
}

#' @export
#' @importFrom ggraph ggraph geom_edge_fan geom_node_label
#' @importFrom dplyr %>% mutate rowwise
#' @importFrom tidygraph activate
#' @importFrom ggplot2 aes
plot.vlmcfit <- function(x){
    m <- ncol(x$probs) - 4
    graph <- tree_graph(x) %>%
        activate(nodes) %>%
        mutate(lab = ifelse(probs_chr == "  NA   NA", last, paste0(last,"\n", probs_chr)))
    graph %>% 
        ggraph(layout = 'tree') +
               geom_edge_fan() +
               geom_node_label(aes(label = lab))
}
