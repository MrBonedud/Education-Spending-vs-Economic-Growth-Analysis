# ================================
# 04_evaluate.R
# Model Evaluation
# ================================

library(tidyverse)
library(caret)

# --------------------------------
# 1. Load cleaned data
# --------------------------------
df <- read_csv(
  "data/cleaned/wdi_cleaned.csv",
  show_col_types = FALSE
)

# --------------------------------
# 2. Apply trimming rule
# --------------------------------




df <- df %>%
  dplyr::filter(
    .data$gdp_growth >= -20,
    .data$gdp_growth <= 20
  )


# --------------------------------
# 3. Prepare ML dataset
# --------------------------------
ml_df <- df %>%
  select(
    gdp_growth,
    education_spending,
    unemployment,
    inflation,
    population_growth
  ) %>%
  drop_na()

# --------------------------------
# 4. Recreate train/test split
# --------------------------------
set.seed(42)

train_idx <- createDataPartition(
  ml_df$gdp_growth,
  p = 0.7,
  list = FALSE
)

train_df <- ml_df[train_idx, ]
test_df  <- ml_df[-train_idx, ]

# --------------------------------
# 5. Load trained model
# --------------------------------
rf_model <- readRDS(
  "outputs/models/random_forest_model.rds"
)

# --------------------------------
# 6. Generate predictions
# --------------------------------
test_predictions <- predict(
  rf_model,
  newdata = test_df
)

# --------------------------------
# 7. Compute evaluation metrics
# --------------------------------
rmse_value <- RMSE(
  pred = test_predictions,
  obs  = test_df$gdp_growth
)

r2_value <- R2(
  pred = test_predictions,
  obs  = test_df$gdp_growth
)

metrics <- tibble(
  RMSE = rmse_value,
  R_squared = r2_value
)

print(metrics)

# --------------------------------
# 8. Save evaluation metrics
# --------------------------------
write_csv(
  metrics,
  "outputs/models/ml_evaluation_metrics.csv"
)

# --------------------------------
# 9. Save predictions
# --------------------------------
predictions_df <- tibble(
  actual_gdp_growth = test_df$gdp_growth,
  predicted_gdp_growth = test_predictions
)

write_csv(
  predictions_df,
  "outputs/models/ml_predictions.csv"
)

# --------------------------------
# 10. Evaluation plot
# --------------------------------
p <- ggplot(
  predictions_df,
  aes(
    x = actual_gdp_growth,
    y = predicted_gdp_growth
  )
) +
  geom_point(alpha = 0.5) +
  geom_abline(
    intercept = 0,
    slope = 1,
    color = "red",
    linetype = "dashed"
  ) +
  labs(
    title = "Predicted vs Actual GDP Growth",
    x = "Actual GDP Growth",
    y = "Predicted GDP Growth"
  ) +
  theme_minimal()

print(p)

# Save plot
ggsave(
  filename = "outputs/plots/predicted_vs_actual_gdp_growth.png",
  plot = p,
  width = 8,
  height = 6
)

