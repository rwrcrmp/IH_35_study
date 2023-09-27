## load libraries
libs <- c("tidyverse", "sf")

lapply(libs, library, character.only = T)

rm(libs)

# load datasets
atx_hex <- st_read("Desktop/IH_35_study/data/created_files/atx_hex/atx_hex.shp")

source("Desktop/IH_35_study/R/multi_path.R")

sim_trial <- multi_path(atx_hex, 2, 10)

# test plot
atx_hex |> 
  filter(FID %in% c(
    sim_trial[[1]],
    sim_trial[[2]]
      )
    ) |>
  ggplot() + 
  geom_sf() +
  geom_sf_label(aes(label = FID)) +
  theme_void()
