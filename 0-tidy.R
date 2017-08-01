# devtools::install_github('jeremystan/tidyjson',ref='f6f13f4')
# Dev version of tidyjson fixes problem with dplyr, i think..?

library(tidyjson)
library(magrittr)
library(dplyr)
library(tidyr)


json_df <- read_json("data/db.json", "jsonl")
temp <- json_df %>% sample_n(5)  # Small subset to test functions


# ------------------------------------------------------------------------------
# View heirarchy to help decide on a table structure
#
jsonlite::prettify(as.tbl_json(json_df)[1, 1])


# ------------------------------------------------------------------------------
# Separate data into two tidy tables
#
players <- json_df %>%
  spread_values(
    id         = json_chr("uniqueId"),
    name       = json_chr("displayName"),
    platform   = json_chr("platform", "name"),
  # start_date = json_dbl("createdAt"),  # Not sure what this means
    shots      = json_dbl("stats", "shots"),
    saves      = json_dbl("stats", "saves"),
    mvps       = json_dbl("stats", "mvps"),
    goals      = json_dbl("stats", "goals"),
    assists    = json_dbl("stats", "assists"),
    wins       = json_dbl("stats", "wins")
  )

# anytime::anytime(1468013823)  # Convert createdAt if we decide to use it

# This takes a few minutes
rank <- json_df %>%
  spread_values(
    id = json_chr("uniqueId")
  ) %>%
  enter_object("rankedSeasons") %>%
  spread_all() %>%
  gather(key, val, -c(document.id, id)) %>%
  separate(key, 
           c("season", "game_type", "stats"), 
           sep = "\\.") %>%
  spread(stats, val) %>%
  rename(
    matches_played = matchesPlayed, 
    mmr            = rankPoints, 
    rank           = tier
  )


# ------------------------------------------------------------------------------
# Save and load faster
#
saveRDS(players, "data/players.Rds")
saveRDS(rank, "data/rank.Rds")

players <- readRDS("data/players.Rds")
rank <- readRDS("data/rank.Rds")