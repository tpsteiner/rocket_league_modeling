library(tidyverse)
library(corrplot)
library(magrittr)


players <- readRDS("data/raw/players.Rds")
rank <- readRDS("data/raw/rank.Rds")


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
# Tier distributions for each ranked game type for season 5

head(rank)

# Re-label and re-type tier as factor for plots (index 1:19)
tier_labels <- c('Unranked', 
                 'Bronze I', 'Bronze II', 'Bronze III',
                 'Silver I', 'Silver II', 'Silver III', 
                 'Gold I', 'Gold II', 'Gold III', 
                 'Platinum I', 'Platinum II', 'Platinum III',
                 'Diamond I', 'Diamond II', 'Diamond III', 
                 'Champion I', 'Champion II', 'Champion III', 
                 'Grand Champion')

rank$tier <- factor(rank$tier, labels = tier_labels)

# For each game type in season 5...
# 1. Create chart-ready data frame to simplify plotting
# 2. Plot a bar chart to match the distributions plots 
#    on the Global page of rocketleaguestats.com

################# Season 5
################# Ranked Duel

s5_duel <- rank %>%
  filter(season == 5, tier != "Unranked", game_type == 10) %>%
  group_by(tier, game_type) %>%
  summarise(freq = n(), dist = freq/nrow(.)) %>%
  mutate(bar_labels = paste(freq, "(", round(dist * 100, 2), "%)"))

s5_duel %>%
  ggplot() + 
  geom_bar(aes(tier, dist), stat="identity") +
  geom_text(aes(tier, dist, label = bar_labels), hjust=0) +
  scale_y_continuous(limits = c(0, .13), labels = scales::percent) +
  ggtitle("Season 5 Player Distribution", "Ranked Duel") +
  ylab(paste("Percent of ", sum(s5_duel$freq), " players")) +
  coord_flip()

################# Season 5
################# Ranked Doubles

s5_doubles <- rank %>%
  filter(season == 5, tier != "Unranked", game_type == 11) %>%
  group_by(tier, game_type) %>%
  summarise(freq = n(), dist = freq/nrow(.)) %>%
  mutate(bar_labels = paste(freq, "(", round(dist * 100, 2), "%)"))

s5_doubles %>%
  ggplot() + 
  geom_bar(aes(tier, dist), stat="identity") +
  geom_text(aes(tier, dist, label = bar_labels), hjust=0) +
  scale_y_continuous(limits = c(0, .13), labels = scales::percent) +
  ggtitle("Season 5 Player Distribution", "Ranked Doubles") +
  ylab(paste("Percent of ", sum(s5_doubles$freq), " players")) +
  coord_flip()

################# Season 5
################# Ranked Solo Standard

s5_ss <- rank %>%
  filter(season == 5, tier != "Unranked", game_type == 12) %>%
  group_by(tier, game_type) %>%
  summarise(freq = n(), dist = freq/nrow(.)) %>%
  mutate(bar_labels = paste(freq, "(", round(dist * 100, 2), "%)"))

s5_ss %>%
  ggplot() + 
  geom_bar(aes(tier, dist), stat="identity") +
  geom_text(aes(tier, dist, label = bar_labels), hjust=0) +
  scale_y_continuous(limits = c(0, .13), labels = scales::percent) +
  ggtitle("Season 5 Player Distribution", "Ranked Solo Standard") +
  ylab(paste("Percent of ", sum(s5_ss$freq), " players")) +
  coord_flip()

################# Season 5
################# Ranked Standard

s5_std <- rank %>%
  filter(season == 5, tier != "Unranked", game_type == 13) %>%
  group_by(tier, game_type) %>%
  summarise(freq = n(), dist = freq/nrow(.)) %>%
  mutate(bar_labels = paste(freq, "(", round(dist * 100, 2), "%)"))

s5_std %>%
  ggplot() + 
  geom_bar(aes(tier, dist), stat="identity") +
  geom_text(aes(tier, dist, label = bar_labels), hjust=0) +
  scale_y_continuous(limits = c(0, .13), labels = scales::percent) +
  ggtitle("Season 5 Player Distribution", "Ranked Standard") +
  ylab(paste("Percent of ", sum(s5_std$freq), " players")) +
  coord_flip()

# Although counts differ for rank dist for each ranked game type for season 4,
# the density distributions look very similar
# the most apparent difference is high density of tier 0 players in game type 10
# and higher density of higher tier players in game type 11
rank %>% 
  filter(season == 4) %>%
  group_by(tier, game_type) %>%
  mutate(freq = n()) %>%
  ggplot() + 
  geom_density(aes(tier)) + 
  facet_wrap(~game_type)


# Rank distribution for each ranked game type and division for season 4
# (note from James: not sure if this even makes intuitive sense)
# division 0 has the most newbs across all game types

rank %>% 
  filter(season == 4) %>%
  group_by(division, tier, game_type) %>%
  mutate(freq = n()) %>%
  ggplot() +
  geom_density(aes(tier)) +
  facet_wrap(c("game_type","division")) +
  ggtitle("tier density distribution for each game type and division")

