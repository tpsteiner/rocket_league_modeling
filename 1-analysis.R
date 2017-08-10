library(tidyverse)
library(corrplot)
library(magrittr)


players <- readRDS("data/players.Rds")
rank <- readRDS("data/rank.Rds")


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

# More goals per player are scored in 1v1 than 3v3. Goal cannot be
# calculated because all game_type wins/goals are grouped together

# ------------------------------------------------------------------------------
players %>% 
  # filter out cases where goals > shots, 158 cases of this in dataset
  filter(goal_pct < 1) %>%
  ggplot(aes(x = goals, y = goal_pct)) +
  geom_point(alpha = 0.1) +
  geom_smooth(method = lm) +
  ggtitle("Goals vs Goal Percent") +
  theme_bw()

# Check out the count of wins. The data is not wrong. RL's system for
# identifying shots is not perfect.
players %>% filter(goal_pct >= 1) %>% arrange(wins)


# ------------------------------------------------------------------------------
# Rank distributions for each ranked game type for season 4

head(rank)

rank %>% 
  filter(season == 4) %>%
  group_by(tier, game_type) %>%
  mutate(freq = n()) %>%
  ggplot() + 
  geom_bar(aes(tier)) + 
  facet_wrap(~game_type) +
  geom_text(aes(tier, freq, label = tier), nudge_y = 25)

best_mmr <- 
  rank %>%
  group_by(id, season) %>%
  summarise(avg_mmr = round(sum(mmr) / n())) %>%
  ungroup() %>% group_by(id) %>%
  summarise(best_mmr = max(avg_mmr))

players %<>%
  left_join(best_mmr)

fit1 <- lm(best_mmr ~ saves, data = players)
summary(fit1)

# MVPs results in highest adj r^2 at .5, with saves right after at .49
# Saves probably tells a better story
