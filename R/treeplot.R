#' @importFrom stringr str_remove_all str_split str_length str_trunc str_detect
#' @importFrom tidygraph tbl_graph
#' @export
tree_graph <- function(leaves){
    leaves <- str_remove_all(leaves, "\\{")
    leaves <- str_remove_all(leaves, "\\}")
    leaves <- str_split(leaves, pattern = ",")
    leaves <- unlist(leaves)
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
#' @importFrom ggplot2 aes
tree_plot <- function(leaves){
    return(ggraph(tree_graph(leaves), layout = 'tree') +
               geom_edge_fan() +
               geom_node_label(aes(label = last)))
}
