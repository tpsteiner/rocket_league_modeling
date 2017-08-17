# library(devtools)
# install_github("josegallegos07/steamR")
library(steamR)
library(tidyverse)


STEAM_KEY = "1D7EE9848468B74ABFD4FC8CA0CD7475"
USER_ID = "76561197971032146"
APP_ID = 252950

players <- readRDS("./data/raw/players.rds")


steam <- players %>% 
  group_by_all() %>% 
  do(
    games = get_owned_games(STEAM_KEY, .$id),
    friends = get_friend_list(STEAM_KEY, .$id, relationship = "all"),
    achv = get_user_stats_for_game(STEAM_KEY, .$id, APP_ID),
    info = get_player_summaries(STEAM_KEY, .$id)
  )


saveRDS(steam, "steam.RDS")