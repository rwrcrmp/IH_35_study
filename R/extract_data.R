## load libraries
libs <- c('tidyverse', 'RSocrata')

lapply(libs, library)

rm(libs)

## define data sources and pull data

# in-use ------------------------------------------------------------------

## EXTRACT CRASH DATA ##

url <- "https://data.austintexas.gov/resource/y2wy-tgr5.json"

atx_crash_raw <- read.socrata(url)

write_csv(atx_crash_raw, "data/extracted_data/atx_crash_raw.csv")

# API calls don't pull shapefiles / zip files don't pull effectively
# not sure why, for now just extract manually

## EXTRACT ATX BOUNDARY ##

# download from ::

# https://data.austintexas.gov/dataset/BOUNDARIES_jurisdictions/vnwj-xmz9

## EXTRACT STREET CENTER LINES ##

# download from ::

# https://data.austintexas.gov/dataset/Street-Centerline/8hf2-pdmb

# unused ------------------------------------------------------------------