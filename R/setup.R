### this script installs packages and builds 
### directory structure for an initial git commit

## install packages

# list packages you need for your project, update as needed
packages <- c("tidyverse", "sf", "readxl",
              "renv", "quarto", "sfdep",
              "leaflet", "htmltools", "htmlwidgets")

# iterate over character vector to install packages
lapply(packages, install.packages)

# when necessary, install packages from source
install.packages("E:/R/RSocrata_1.7.12-4.tar.gz", repos = NULL, type = "source")

# capture packages in `renv` lockfile
renv::snapshot()

## build repo directory
folders <- c("data", "data/extracted_files", "data/created_files", "data/archive", 
             "R", "R/archive", 
             "assets", "assets/datasets", "assets/images", 
             "products", "products/datasets", "products/documents", "products/html")

# iterate over character vector to create folders and subfolders
lapply(folders, dir.create)

# create initial R files
R_files <- c("extract_data", "build_assets", "build_products")

for (i in R_files){
  x <- paste0("R/", i, ".R")
  file.create(x)
}

# create initial quarto file
file.create("products/report.qmd")

# create temporary files to populate empty folders
for (i in folders){
  x <- paste0(i, "/temp.txt")
  file.create(x)
}

## push initial commit

# after pushing initial commit remove temp files and R objects
for (i in folders){
  x <- paste0(i, "/temp.txt")
  file.remove(x)
}

# finish by removing all R objects
rm(list = ls())