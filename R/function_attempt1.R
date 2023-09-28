# trying to build a function for loop to run random walk

# choose random location on grid

# data must be a vector of unique ids corresponding
# to tiled polygons

random_walk <-function(df, steps, n.trials){
  
  # create vector of numbered ids
  df$id = 1:nrow(df)
    
  # create adjacency matrix
  adj_mtx = st_touches(df, df)
  
  # match names to df ids
  names(adj_mtx) <- 1:nrow(df)
  
  # pull list of ids to run trials
  start_pts = sample(df$id, n.trials)
  
  # generate empty data frame
  trials = data.frame()
  
  # iterate over list of trials
  for(i in seq_along(start_pts)){
    
    # start path
    path = start_pts[i]
    
    # take ten steps
    for(j in seq_len(steps)){
      
      # find next step
      nb_q = adj_mtx[[path[j]]]
      
      # take next step
      x = sample(nb_q, 1)
      
      # combine steps to create path
      y = c(x, y)
    }
    
    # append steps to path
    path = c(path, y)
    
    # combine into data frame
    trials = cbind(trials, path)
    
    # apply column names
    colnames(trials) = paste("walk", 1:ncol(trials)
  }
}


random_walk(atx_hex, 10, 10)
