# library(devtools)
# install_github("josegallegos07/steamR")
# library(steamR)
library(tidyverse)
library(httr)
library(tidyjson)

STEAM_KEY = "1D7EE9848468B74ABFD4FC8CA0CD7475"
USER_ID = "76561197971032146"
APP_ID = 252950

players <- readRDS("./data/raw/players.rds")
s <- players[sample(1:nrow(players), 5), ]


# API functions
# ------------------------------------------------------------------------------
get_owned_games <- function(key, steamid){
  r <- httr::GET("https://api.steampowered.com/IPlayerService/GetOwnedGames/v1/",
                 query = list(key = key, steamid = steamid))
  
  if (r$status_code != 200) return(NA)
  
  c <- content(r, "parsed")
  d <- c$response
  jsonlite::toJSON(d)
}

get_steam_level <- function(key, steamid){
  r <- httr::GET("https://api.steampowered.com/IPlayerService/GetSteamLevel/v1/",
                 query = list(key = key, steamid = steamid))
  
  if (r$status_code != 200) return(NA)
  
  c <- content(r, "parsed")
  d <- c$response
  jsonlite::toJSON(d)
}

get_friend_list <- function(key, steamid){
  r <-httr::GET("https://api.steampowered.com/ISteamUser/GetFriendList/v1/",
                query = list(key = key, steamid = steamid, relationship = "all"))
  
  if (r$status_code != 200) return(NA)
  
  c <- content(r, "parsed")
  jsonlite::toJSON(c)
}

get_player_summaries <- function(key, steamids){
  r <- httr::GET("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/",
                 query = list(key = key, steamids = steamids))
  
  if (r$status_code != 200) return(NA)
  
  c <- content(r, "parsed")
  d <- c$response
  jsonlite::toJSON(d)
}

get_player_achievements <- function(key, steamid, appid){
  r <- httr::GET("https://api.steampowered.com/ISteamUserStats/GetPlayerAchievements/v1/",
                 query = list(key = key, steamid = steamid, appid = appid))
  
  if (r$status_code != 200) return(NA)
  
  c <- content(r, "parsed")
  jsonlite::toJSON(c)
}


# Call API functions
# ------------------------------------------------------------------------------

steam <- players %>%
  group_by_all() %>%
  do(
    games       = get_owned_games(STEAM_KEY, .$id),
    steam_level = get_steam_level(STEAM_KEY, .$id),
    friends     = get_friend_list(STEAM_KEY, .$id),
    info        = get_player_summaries(STEAM_KEY, .$id),
    achv        = get_player_achievements(STEAM_KEY, .$id, APP_ID)
  )

# y <- steam %>%
#   select(id, games) %>%
#   as.tbl_json(json.column = "games") %>%
#   spread_values(
#     game_count = json_dbl("JSON", "game_count")
#   )

saveRDS(steam, "steam.RDS")
