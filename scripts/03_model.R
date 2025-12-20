library(tidyverse)
library(broom)
library(caret)

# --------------------------------
# Load cleaned & trimmed data
# --------------------------------

df <- read_csv("data/cleaned/wdi_cleaned.csv", show_col_types = FALSE)

df_trimmed <- df %>%
  dplyr::filter(
    .data$gdp_growth >= -20,
    .data$gdp_growth <= 20
  )

# --------------------------------
# Baseline linear regression
# --------------------------------
# GDP growth explained only by education spending
# --------------------------------

model_1 <- lm(
  gdp_growth ~ education_spending,
  data = df_trimmed
)

summary(model_1)

# --------------------------------
# Model 2: Add macroeconomic controls
# --------------------------------

model_2 <- lm(
  gdp_growth ~ education_spending + unemployment + inflation + population_growth,
  data = df_trimmed
)

summary(model_2)

library(broom)

# --------------------------------
# Tidy regression outputs
# --------------------------------

model1_tidy <- tidy(model_1)
model2_tidy <- tidy(model_2)

model1_tidy
model2_tidy

# --------------------------------
# Clean variable names for tables
# --------------------------------

clean_terms <- function(term) {
  case_when(
    term == "(Intercept)" ~ "Intercept",
    term == "education_spending" ~ "Education spending (% of GDP)",
    term == "unemployment" ~ "Unemployment rate (%)",
    term == "inflation" ~ "Inflation rate (%)",
    term == "population_growth" ~ "Population growth (%)",
    TRUE ~ term
  )
}

model1_tidy <- model1_tidy %>%
  mutate(term = clean_terms(term))

model2_tidy <- model2_tidy %>%
  mutate(term = clean_terms(term))

model1_tidy

model2_tidy


# --------------------------------
# Format regression tables
# --------------------------------

add_stars <- function(p) {
  case_when(
    p < 0.001 ~ "***",
    p < 0.01  ~ "**",
    p < 0.05  ~ "*",
    TRUE      ~ ""
  )
}

model1_table <- model1_tidy %>%
  mutate(
    estimate = round(estimate, 3),
    std.error = round(std.error, 3),
    stars = add_stars(p.value)
  ) %>%
  select(term, estimate, std.error, stars)

model2_table <- model2_tidy %>%
  mutate(
    estimate = round(estimate, 3),
    std.error = round(std.error, 3),
    stars = add_stars(p.value)
  ) %>%
  select(term, estimate, std.error, stars)

model1_table
model2_table


# --------------------------------
# Combine Model 1 and Model 2 tables
# --------------------------------

model1_table <- model1_table %>%
  rename(
    estimate_m1 = estimate,
    se_m1 = std.error,
    stars_m1 = stars
  )

model2_table <- model2_table %>%
  rename(
    estimate_m2 = estimate,
    se_m2 = std.error,
    stars_m2 = stars
  )

# --------------------------------
# Merge Model 1 and Model 2 tables
# --------------------------------

regression_table <- full_join(
  model1_table,
  model2_table,
  by = "term"
)

regression_table

# --------------------------------
# Format coefficients for presentation (FIXED)
# --------------------------------

final_table <- regression_table %>%
  mutate(
    Model_1 = pmap_chr(
      list(estimate_m1, se_m1, stars_m1),
      ~ format_coef(..1, ..2, ..3)
    ),
    Model_2 = pmap_chr(
      list(estimate_m2, se_m2, stars_m2),
      ~ format_coef(..1, ..2, ..3)
    )
  ) %>%
  select(term, Model_1, Model_2)

final_table

# --------------------------------
# Save regression table
# --------------------------------

write_csv(
  final_table,
  "outputs/models/table_3_regression_results.csv"
)


# --------------------------------
# Machine Learning Model (Regression)
# Random Forest via caret
# --------------------------------


set.seed(42)

# Prepare ML dataset
ml_df <- df_trimmed %>%
  select(
    gdp_growth,
    education_spending,
    unemployment,
    inflation,
    population_growth
  ) %>%
  drop_na()

# Train/test split
train_idx <- createDataPartition(ml_df$gdp_growth, p = 0.7, list = FALSE)
train_df <- ml_df[train_idx, ]
test_df  <- ml_df[-train_idx, ]

# Train Random Forest model
rf_model <- train(
  gdp_growth ~ .,
  data = train_df,
  method = "rf",
  trControl = trainControl(method = "cv", number = 5)
)

rf_model

# --------------------------------
# Save trained ML model
# --------------------------------

saveRDS(
  rf_model,
  "outputs/models/random_forest_model.rds"
)
