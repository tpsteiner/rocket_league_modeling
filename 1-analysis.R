library(tidyverse)
library(corrplot)


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
  
# ------------------------------------------------------------------------------
# two mutations to dataset
players$cume_dist = cume_dist(players$wins) # cumulative distribution column based on wins
players = players %>% mutate(goal_pct = goals / shots) # goal efficiency metric
players = players %>% arrange(desc(wins), desc(goals)) # arrange dataset by wins and then goals 


# ------------------------------------------------------------------------------
# distribution similar for all numeric vars, as shown by corrplot
corrplot(cor(players[,5:10]), type = "lower", method = "number")


# ------------------------------------------------------------------------------
# cumulative distribution function plots of numeric variables
# show that many players have similar metrics below 80th-90th percentile rank
plot(ecdf(players$shots))
plot(ecdf(players$saves))
plot(ecdf(players$mvps))
plot(ecdf(players$goals))
plot(ecdf(players$assists))
plot(ecdf(players$wins))


# ------------------------------------------------------------------------------
# looking at win distribution for the top 10% of players
players %>% 
  # filter for top 10% of players based on wins
  filter(cume_dist >= 0.90) %>% 
  ggplot(aes(x = wins)) + 
  geom_histogram(bins = 30) +
  ggtitle("Win Distribution for Top 10% of Players") +
  theme_bw()


# ------------------------------------------------------------------------------
players %>% 
  # filter out cases where goals > shots, 158 cases of this in dataset
  filter(goal_pct < 1) %>%
  ggplot(aes(x = goals, y = goal_pct)) +
  geom_point(alpha = 0.1) +
  geom_smooth(method = lm) +
  ggtitle("Goals vs Goal Percent") +
  theme_bw()



