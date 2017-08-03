library(tidyverse)


players <- readRDS("data/players.Rds")
rank <- readRDS("data/rank.Rds")

# ------------------------------------------------------------------------------
# No "Total games" stat. Most players have around 50% win rate.
# All player stats have nearly the same distribution as expected
# Only use one in a model

plot
ggplot(players) + 
  geom_histogram(aes(wins), bins = 100) + 
  coord_cartesian(c(0, 2000), c(0, 10000)) +
  ggtitle("wins")


# ------------------------------------------------------------------------------
ggplot(players) + 
  geom_histogram(aes(shots), bins = 100) +
  coord_cartesian(c(0, 10000), c(0, 10000)) +
  ggtitle("shots")


# ------------------------------------------------------------------------------
ggplot(players) + 
  geom_histogram(aes(saves), bins = 100) +
  coord_cartesian(c(0, 3000), c(0, 10000)) +
  ggtitle("saves")


# ------------------------------------------------------------------------------
ggplot(players) + 
  geom_histogram(aes(mvps), bins = 100) +
  coord_cartesian(c(0, 1000), c(0, 10000)) +
  ggtitle("mvps")


# ------------------------------------------------------------------------------
ggplot(players) + 
  geom_histogram(aes(goals), bins = 100) +
  coord_cartesian(c(0, 5000), c(0, 10000)) +
  ggtitle("goals")


# ------------------------------------------------------------------------------
ggplot(players) + 
  geom_histogram(aes(assists), bins = 100) +
  coord_cartesian(c(0, 2500), c(0, 10000)) +
  ggtitle("assists")




