

adjaceny_matrix = sf::st_touches(atx_hex, atx_hex)

start_pts = as.integer(sample(atx_hex$FID, 10))

path = sample(start_pts, 1)

for(i in 1:10){
  
  neighbors = adjaceny_matrix[[tail(path[i])]]
  
  neighbors = neighbors[!neighbors %in% path]
  
  nth.step = sample(neighbors, 1)
  
  path = c(path, nth.step)
}

path

atx_hex |> 
  filter(FID %in% c(path)) |>
  ggplot() + 
  geom_sf() +
  geom_sf_label(aes(label = FID)) +
  theme_void()
