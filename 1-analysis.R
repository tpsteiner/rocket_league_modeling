library(tidyverse)

players <- readRDS("data/players.Rds")
rank <- readRDS("data/rank.Rds")

# remove rows with NA values
players = players[complete.cases(players),]

# cumulative distribution function plots of numeric variables
# show that many players have similar metrics below 80th-90th percentile rank
# distribution similar for all vars, as shown by corrplot
plot(ecdf(players$shots))
plot(ecdf(players$saves))
plot(ecdf(players$mvps))
plot(ecdf(players$goals))
plot(ecdf(players$assists))
plot(ecdf(players$wins))

# cumulative distribution column based on wins
players$cume_dist = cume_dist(players$wins) 

# create goal efficiency metric
players = players %>% mutate(goal_pct = goals / shots)

# correlation plot graphic for numerical variables
corrplot::corrplot(cor(players[,5:10]), type = "lower", method = "number")

# looking at top 10% of players
players90 = players %>% 
  # arrange by wins and goals
  arrange(desc(wins), desc(goals)) %>% 
  # filter for top 10% of players based on wins
  filter(cume_dist >= 0.90)

# plotting histogram of wins for top 10% of players
players90 %>% ggplot(aes(x = wins)) + 
  geom_histogram(bins = 30) +
  ggtitle("Win Distribution for Top 10% of Players") +
  theme_bw()

# plot comparison of goals versus goal_pct
players %>% 
  # filter out cases where goals > shots
  filter(goal_pct < 1) %>%
  ggplot(aes(x = goals, y = goal_pct)) +
  geom_point(alpha = 0.1) +
  geom_smooth(method = lm) +
  ggtitle("Goals vs Goal Percent") +
  theme_bw()
