library(tidyjson)
library(magrittr)
library(readr)
library(dplyr)


# ------------------------------------------------------------------------------
# View heirarchy to help decide on a table structure

temp <- read_lines("data/db.json") %>% .[c(T, F)]
jsonlite::prettify(x[1])


# ------------------------------------------------------------------------------
# Tidy the data

df <- read_json("data/db.json", "jsonl")


# ------------------------------------------------------------------------------
# Save and load faster
saveRDS(df, "data/rl_json.Rds")
df <- readRDS("data/rl_json.Rds")