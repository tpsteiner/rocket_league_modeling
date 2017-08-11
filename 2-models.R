library(tidyverse)
library(broom)     # To tidy model data
library(magrittr)  # Includes exposition pipe %$% and tee pipe %T>%
library(printr)    # Printing tables to console is neater

players <- readRDS("data/raw/players.Rds")
rank    <- readRDS("data/raw/rank.Rds")


# ------------------------------------------------------------------------------
# Organize the data into a tidy, model-ready data frame

# Label game_type and make it a factor variable for modeling
game_type_labels <- c(rep(NA, 9),"Ranked Duel", "Ranked Doubles", 
                      "Ranked Solo Standard", "Ranked Standard")

rank$game_type <- rank %$%
  as.integer(game_type) %>%
  game_type_labels[.]

# Keep only that data that we need to simplify modeling
model_data <- rank %>%
  filter(season == 5) %>%
  inner_join(players, by = "id") %>%
  select(mmr, game_type, id, name, matches_played,  
         shots, saves, mvps, goals, assists, wins) %>%
  gather(stat, stat_value, -c(1:4))

# Split the data into train/test data sets to reduce bias error
n <- nrow(model_data)
s <- sample(1:n, n*.8)

train <- model_data[s, ]
test  <- model_data[-s, ]

# Add a column of linear models that can be tidied with broom
mmr_models <- model_data %>%
  group_by(game_type, stat) %>%
  do(
    mod = lm(mmr ~ stat_value, data = .),
    original = (.)
    )


# ------------------------------------------------------------------------------
# Use broom to investigate models
# Linear models output stats for three observational units:
#   1. Model
#   2. Coefficient
#   3. Sample
# Following the "tidy" methodology, we will need 
# to create three tables to hold the data

## Coefficients (component-level stats):
## - All coefficients are significant. This is expected, 
##   because all stats increase with time
mmr_coef <- tidy(mmr_models, mod) %T>% print()

## Predictions (observation-level stats):
mmr_pred <- augment(mmr_models, mod, data = original) %T>% print()

## Summary statistics (model-level stats):
mmr_ss <- glance(mmr_models, mod) %T>% print() 
