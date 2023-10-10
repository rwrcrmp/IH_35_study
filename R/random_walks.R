## load libraries
libs <- c("tidyverse", "sf")

lapply(libs, library, character.only = T)

rm(libs)

# load datasets
atx_hex <- st_read("data/created_files/atx_hex/atx_hex.shp")

source("R/multi_path.R")

sim_trial <- multi_path(atx_hex, 10, 10)

# test plot
atx_hex |> 
  filter(FID %in% sim_trial[[5]]) |>
  ggplot() + 
  geom_sf() +
  geom_sf_label(aes(label = FID)) +
  theme_void()

atx_walks <- atx_hex |>
  left_join(
    sim_trial |>
      as.data.frame() |>
      pivot_longer(everything(),
                   names_to = "walk",
                   values_to = "FID")
  )

# test plot
atx_walks |>
  filter(walk == "walk_5") |>
  ggplot() +
  geom_sf(aes(fill = walk)) +
  theme_void()
