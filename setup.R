### this script installs packages and builds directory structure for an initial git commit ###

## install packages

# list packages you need for your project, update as needed
packages <- c("tidyverse", "sf", "RSocrata", "readxl",
              "renv", "quarto", "sfdep",
              "leaflet", "htmltools", "htmlwidgets")

# iterate over character vector to install packages
lapply(packages, install.packages)

# capture packages in `renv` lockfile
renv::snapshot()

## build repo directory
folders <- c("data", "data/extracted_files", "data/created_files", "data/archive", 
             "R", "R/archive", 
             "assets", "assets/images", 
             "products", "products/documents", "products/html")

# iterate over character vector to create folders and subfolders
lapply(folders, dir.create)

# create temporary files for initial commit
for (i in folders){
  x <- paste0(i, "/temp.txt")
  file.create(x)
}

# after pushing initial commit remove temp files and R objects
for (i in folders){
  x <- paste0(i, "/temp.txt")
  file.remove(x)
}

rm(list = ls())
