
# ------------------------------------------------------------------------------
# Simple linear regression model matrix
# Number of models is number of game types times number of player stats

players <- readRDS("data/raw/players.Rds")
rank <- readRDS("data/raw/rank.Rds")

# 10, 11, 12, 13
game_type_labels <- c(rep(NA, 9),"Ranked Duel", "Ranked Doubles", 
                      "Ranked Solo Standard", "Ranked Standard")

factor(rank$game_type, levels = game_type_labels)
# Start by organizing the data into a tidy, model-ready data frame
model_data <- rank %>%
  filter(season == 5) %>%
  inner_join(players, by = "id") %>%
  select(id, game_type, tier, division, mmr, matches_played, 
         shots, saves, mvps, goals, assists, wins)



# vignette(package="broom")
# vignette("broom_and_dplyr")

fit1 <- lm(best_mmr ~ saves, data = players)
summary(fit1)
# MVPs results in highest adj r^2 at .5, with saves right after at .49
# Saves probably tells a better story: saves is the most correlated with MMR

plot(fit1)
# Residuals vs Fitted
#   - Predicted MMR is normally over-estimated when MMR > 1000
#   - Could be due to saves being less important past 1000 MMR
#
# Normal Q-Q
#   - The distribution of the residuals is mostly normal, but edge 
#     cases are larger than edge cases of a normal distribution
#
# 
