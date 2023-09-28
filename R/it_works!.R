multi_path <- function(df, n.paths, n.steps){
  
  #############################################
  df$id = 1:nrow(df)

  adj_mtx = sf::st_touches(df, df)
  
  start_pts = as.integer(sample(df$id, n.paths))
  #############################################
  
  single_path <- function(x){
    
    x = sample(start_pts, 1)
    
    for(i in 1:n.steps){
      nb_q = adj_mtx[[x[i]]]
      y = sample(nb_q, 1)
      x = c(x, y)
    }
    return(x)
  }
  
  paths_list <- lapply(start_pts, single_path)
  
  names(paths_list) = paste0(
    "walk_", as.character(1:length(paths_list))
  )
  
  return(paths_list)
}

sim_trial <- multi_path(atx_hex, 10, 20)
