## load libraries
libs <- c("tidyverse", "sf", "sfdep")

lapply(libs, library, character.only = T)

rm(libs)

# load datasets
atx_hex <- st_read("data/created_files/atx_hex/atx_hex.shp")

# generate neighbors and weights
atx_hex.1 <- atx_hex |> 
  mutate(nb = st_contiguity(geometry),
         wt = st_weights(nb))

begin <- sample(atx_hex.1$FID, 1)

nb_queen_1 <- unlist(atx_hex.1$nb[atx_hex.1$FID == begin])

stp_1 <- sample(nb_queen_1, 1)

nb_queen_2 <- unlist(atx_hex.1$nb[atx_hex.1$FID == stp_1])

# test plot
temp_hex_list <- c(stp_1, nb_queen_2)

# begin, stp_1, nb_queen_1, nb_queen_2

atx_hex |> 
  filter(FID %in% temp_hex_list ) |> 
  ggplot() + 
  geom_sf() +
  geom_sf_label(aes(label = FID)) + 
  theme_void()


