## function for creating multiple random walks
## over a tiled polygon set

# inputs: df = dataframe of tiled polygons
#         n.paths = number of paths to generate
#         n.steps = number of steps to take per path
multi_path <- function(df, n.paths, n.steps){
  
  ## create objects ##
  
  # generate unique ids for each polygon
  df$id = 1:nrow(df)

  # produce adjacency matrix with `sf` package
  adjaceny_matrix = sf::st_touches(df, df)
  
  # pull sample of ids into integer vector
  start_pts = as.integer(sample(df$id, n.paths))
  
  ## define internal looping function ##
  single_path <- function(x){
    
    # choose starting polygon
    path = sample(start_pts, 1)
    
    # loop for n.steps
    for(i in 1:n.steps){
      
      # find step
      neighbors = adjaceny_matrix[[path[i]]]
      
      # take step
      nth.step = sample(neighbors, 1)
      
      # store and append step to path
      path = c(path, nth.step)
    }
    return(path)
  }
  
  # compile loops into list
  paths_list <- lapply(start_pts, single_path)
  
  # assign names to list
  names(paths_list) = paste0(
    "walk_", as.character(1:length(paths_list))
  )
  
  return(paths_list)
}