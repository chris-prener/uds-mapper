# === === === === === === === === === === === === === === === === === === === ===

# tidy and standardize UDS crosswalk files

# === === === === === === === === === === === === === === === === === === === ===

# dependencies ####

## functions
source("source/functions/create_crosswalk.R")
source("source/functions/load_crosswalk.R")

# === === === === === === === === === === === === === === === === === === === ===

purrr::map(.x = c(2009:2022), .f = ~create_crosswalk(year = .x, path = "data/"))

# === === === === === === === === === === === === === === === === === === === ===

