## load libraries
libs <- c("tidyverse", "sf")

lapply(libs, library, character.only = T)

rm(libs)

## standard CRS

standard_crs <- "+proj=longlat +datum=WGS84"

# save asset
write(standard_crs, "assets/standard_crs.txt")

## convert atx_city_boundary into convex hull

atx_city_boundary <- st_read("data/extracted_files/BOUNDARIES_jurisdictions/geo_export_8ad7636e-5bb0-4e3f-b8c2-e04485ea40cf.shp")

atx_hull <- atx_city_boundary |> 
  
  #merge multi-line object into hull
  st_combine() |>
  st_convex_hull() |> 
  
  #generate sf object
  st_as_sf()

# test plot
ggplot(atx_hull) + geom_sf()

# save asset
dir.create("data/created_files/atx_hull")
st_write(atx_hull, "data/created_files/atx_hull/atx_hull.shp")

## create hex grid

atx_hex <- atx_hull |> 
  
  # convert polygon to grid
  st_make_grid(n = 35, square = F, flat_topped = T) |> 
  st_intersection(atx_hull) |> 
  st_as_sf() |> 
  
  # ad unique ids to hexes
  mutate(hex_id = row_number())

# test plot
ggplot(atx_hex) + geom_sf()

# save asset
dir.create("data/created_files/atx_hex")
st_write(atx_hex, "data/created_files/atx_hex/atx_hex.shp")

## transform atx_crash_raw to sf points

atx_crash_raw <- read_csv("data/extracted_files/atx_crash_raw.csv")

atx_crash_pts <- atx_crash_raw |> 
  
  # remove empty coordinate fields
  filter(!is.na(longitude) | !is.na(latitude)) |>
  
  # generate sf object
  st_as_sf(coords = c("longitude", "latitude"),
           
           # conform CRS to base layer
           crs = st_crs(atx_hull))

# test plot
ggplot(atx_crash_pts) + geom_sf()

# save asset
dir.create("data/created_files/atx_crash_pts")
st_write(atx_crash_pts, "data/created_files/atx_crash_pts/atx_crash_pts.shp")

## create st_buffer

atx_road_lines <- st_read("data/extracted_files/Street Centerline/geo_export_2da675db-b505-4e2b-bc1a-8e738b82806c.shp")

IH_35_buff <- atx_road_lines |>
  filter(prefix_typ == "IH") |>
  
  # # conform CRS to base layer 
  st_transform(crs = st_crs(atx_hull)) |> 
  
  # trim study area to atx hull
  st_join(atx_hull) |>
  st_combine() |>
  
  # convert meters to miles
  st_buffer(dist = 1000 * 0.621371) |> 
  st_as_sf()

# test plot
ggplot(IH_35_buff) + geom_sf()

# save asset
dir.create("data/created_files/IH_35_buff")
st_write(IH_35_buff, "data/created_files/IH_35_buff/IH_35_buff.shp")

