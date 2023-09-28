## load libraries
libs <- c("tidyverse", "sf")

lapply(libs, library, character.only = T)

rm(libs)

# load datasets
atx_hex <- st_read("Desktop/IH_35_study/data/created_files/atx_hex/atx_hex.shp")

# conform hex id to list convention starting at 1 not 0
atx_hex$FID <- 1:nrow(atx_hex)

# create sparse adjacency matrix
adj_mtx <- st_touches(atx_hex, atx_hex)

# set list names to hex id
names(adj_mtx) <- 1:nrow(atx_hex)

# choose random location on grid
path <- sample(atx_hex$FID, 1)

n.steps <- 10

for(i in 1:n.steps){
  nb_q = adj_mtx[[path[i]]]
  x = sample(nb_q, 1)
  path = c(path, x)
}

# test plot
atx_hex |> 
  filter(FID %in% path) |>
  ggplot() + 
  geom_sf() +
  geom_sf_label(aes(label = FID)) +
  theme_void()





