# devtools::install_github('jeremystan/tidyjson',ref='f6f13f4')
# Dev version of tidyjson fixes problem with dplyr

library(tidyjson)
library(magrittr)
library(readr)
library(dplyr)
library(tidyr)


# ------------------------------------------------------------------------------
# View heirarchy to help decide on a table structure
#
temp <- read_lines("data/db.json") %>% .[c(T, F)] # Skip every other line
jsonlite::prettify(temp[1])


# ------------------------------------------------------------------------------
# Tidy the data
#
df <- read_json("data/db.json", "jsonl") %>% head()  # Small subset to test functions

# Split "object" types (lists) from other types for use with tidyjson functions
obj <- df %>% filter(type == "object") %>% select(-type)
nonobj <- df %>% filter(type != "object") %>% select(-type)

# Yo james check these out yo, or delete if not useful, idk
temp <- df %>% gather_object() %>% json_types()
temp2 <- gather_object(obj)
temp2 <- spread_all(obj)
temp3 <- append_chr(nonobj)

# This looks like the right way to get shit done
temp <- df %>%
  enter_object(stats) %>% 
  gather_object() %>% 
  append_dbl()






# ------------------------------------------------------------------------------
# Save and load faster
#
saveRDS(players, "data/players.Rds")
players <- readRDS("data/players.Rds")
