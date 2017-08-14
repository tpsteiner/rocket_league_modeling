library(sqldf)
library(RSQLite)
library(readr)

players <- readRDS("./data/raw/players.RDS")
file <- "D:/data/steam.sql"

df <- read.csv.sql(file, sql = "select * from file.player_summaries where steamid in players.id")

df <- read.csv.sql(file, sql = "select * from file limit 1000 offset 100")

RSQLite::s