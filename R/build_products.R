## load libraries
libs <- c("tidyverse", "sf", "leaflet", "htmltools", "htmlwidgets")

lapply(libs, library, character.only = T)

rm(libs)

## load assets
atx_crash_raw <- read_csv("data/extracted_files/atx_crash_raw.csv")

atx_crash_pts <- st_read("data/created_files/atx_crash_pts/")

IH_35_buff <- st_read("data/created_files/IH_35_buff/IH_35_buff.shp")

atx_hex <- st_read("data/created_files/atx_hex/atx_hex.shp")

# Crash dataset with hwy_buffer label --------------------------------
pts_in_buff <- st_filter(atx_crash_pts, IH_35_buff)

atx_crash_pts_2 <- atx_crash_pts |>
  mutate(
    within_hwy_zone = if_else(
      crash_id %in% pts_in_buff$crash_id, T, F
      )
    )

# test plot
ggplot(atx_crash_pts_2, aes(color = within_hwy_zone)) +
  geom_sf()

dir.create("products/datasets/atx_crash_pts2")
st_write(atx_crash_pts_2, "products/datasets/atx_crash_pts2/atx_crash_pts2.shp")

# keep record of original column names
write(names(atx_crash_pts_2), "assets/keep_names.txt")

# Aggregate crashes to hex grid -------------------------------------------

# spatial join correlate pts to hex
pts_to_hex <- st_join(atx_crash_pts_2, atx_hex)

# drop geometry for calculations
st_geometry(pts_to_hex) <- NULL

# summarize crash data per hex
pts_to_hex_fatal <- pts_to_hex %>% 
  mutate(crash_fatal_fl = if_else(
    crash_fatal_fl == "Y", 1,0)
  ) %>% 
  group_by(hex_id) %>% 
  summarize(crash_cnt = sum(crash_fatal_fl),
            death_cnt = sum(death_cnt))

# rejoin to atx_hex
hex_agg_ftl_crashes <- atx_hex %>% 
  left_join(pts_to_hex_fatal) %>% 
  mutate(
    across(
      where(is.numeric), ~replace(., is.na(.), 0)
    )
  )

dir.create("products/datasets/hex_agg_ftl_crashes")
st_write(hex_agg_ftl_crashes, 
         "products/datasets/hex_agg_ftl_crashes/hex_agg_ftl_crashes.shp")

# write user defined function to run in shiny application
# selection -> generate hex aggregation

# Leaflet map -------------------------------------------------------------

labels <- sprintf(as.character(hex_agg_ftl_crashes$crash_cnt))

pal <- colorNumeric(palette = "magma", 
                    domain = hex_agg_ftl_crashes$crash_cnt)

map_title <- tags$div(HTML('<b>Fatal Crashes in Austin, Texas</b></br>2013-2023'))
map_subtitle<- tags$div(HTML('Source: <a href="https://data.austintexas.gov/Transportation-and-Mobility/Vision-Zero-Crash-Report-Data-Crash-Level-Records/y2wy-tgr5"> City of Austin Open Data Portal </a>'))

widget <- hex_agg_ftl_crashes %>% 
  leaflet(options = leafletOptions(zoomControl = FALSE)) %>% 
  addProviderTiles(providers$CartoDB) %>% 
  setView(lng = -97.78181, 
          lat = 30.33422, 
          zoom = 11) %>% 
  addPolygons(label = labels,
              stroke = FALSE,
              color = "grey",
              smoothFactor = .5,
              opacity = 1,
              fillOpacity = 0.3,
              fillColor = ~pal(crash_cnt),
              highlightOptions = 
                highlightOptions(weight = 2,
                                 fillOpacity = 0.5,
                                 color = "white",
                                 opacity = 1,
                                 bringToFront = TRUE)) %>%
  addControl(map_title, position = "topleft") %>% 
  addLegend(pal = pal,
            values = ~crash_cnt,
            title = "",
            position = "topleft") %>% 
  addControl(map_subtitle, position = 'bottomright')

saveWidget(widget, "products/html/hex_agg_ftl_crashes.html")
