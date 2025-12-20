library(tidyverse)
library(janitor)

df <- read_csv("data/cleaned/wdi_cleaned.csv", show_col_types = FALSE)

# quick sanity check because cleaning the data made me think about jumping off a bridge
glimpse(df)
summary(df$education_spending)
summary(df$gdp_growth)

# --------------------------------
# Global EDA: Education Spending vs GDP Growth
# --------------------------------
# This plot explores the relationship between public education spending
# (as a percentage of GDP) and annual GDP growth across all countries
# and years in the dataset.
#
# Each point represents a country-year observation.
# A linear trend line is added to visualise the overall relationship.
# --------------------------------

p1 <- ggplot(df, aes(x = education_spending, y = gdp_growth)) +
  geom_point(alpha = 0.4) +                 # scatter plot with transparency to reduce overplotting
  geom_smooth(
    method = "lm",
    se = TRUE,
    color = "blue"
  ) +                                       # linear regression trend line with confidence interval
  labs(
    title = "Education Spending vs GDP Growth (Global)",
    x = "Education Spending (% of GDP)",
    y = "GDP Growth (%)"
  ) +
  theme_minimal()                           # clean theme for academic-style plots

# Display the plot
p1

ggsave(
  "outputs/eda_figures/education_vs_gdp_global.png",
  p1,
  width = 8,
  height = 6
)


# --------------------------------
# Remove extreme GDP growth outliers for clearer visualisation
# --------------------------------
# We keep GDP growth values within a reasonable macroeconomic range
# to avoid crisis/rebound years dominating the plot.
# --------------------------------

df_trimmed <- df %>%
  dplyr::filter(
    .data$gdp_growth >= -20,
    .data$gdp_growth <= 20
  )

nrow(df)
nrow(df_trimmed)


# --------------------------------
# Global relationship after trimming extreme GDP growth values
# --------------------------------
# This plot shows the relationship between education spending and
# GDP growth after removing extreme outlier years.
# The goal is to better visualise the central trend.
# --------------------------------

p2 <- ggplot(df_trimmed, aes(x = education_spending, y = gdp_growth)) +
  geom_point(alpha = 0.4) +
  geom_smooth(
    method = "lm",
    se = TRUE,
    color = "blue"
  ) +
  labs(
    title = "Education Spending vs GDP Growth (Global, Trimmed)",
    x = "Education Spending (% of GDP)",
    y = "GDP Growth (%)"
  ) +
  theme_minimal()

# Display plot
p2

ggsave(
  "outputs/eda_figures/education_vs_gdp_global_trimmed.png",
  p2,
  width = 8,
  height = 6
)

# --------------------------------
# Simple correlation check
# --------------------------------
# This provides a numeric summary of the linear association
# between education spending and GDP growth.
# --------------------------------

cor(
  df_trimmed$education_spending,
  df_trimmed$gdp_growth,
  use = "complete.obs"
)


# --------------------------------
# Subset data for Jordan
# --------------------------------
# We create a country-specific subset to compare Jordan
# with the global relationship observed earlier.
# --------------------------------

jordan_df <- df_trimmed %>%
  dplyr::filter(.data$country_name == "Jordan")

nrow(jordan_df)
range(jordan_df$year)

# --------------------------------
# Jordan vs Global comparison plot
# --------------------------------
# Global observations are shown in grey for context.
# Jordan's observations are highlighted in color to
# compare national patterns against the global trend.
# --------------------------------

p_jordan <- ggplot() +
  # Global background
  geom_point(
    data = df_trimmed,
    aes(x = education_spending, y = gdp_growth),
    color = "grey70",
    alpha = 0.3
  ) +
  
  # Jordan points
  geom_point(
    data = jordan_df,
    aes(x = education_spending, y = gdp_growth),
    color = "red",
    size = 2
  ) +
  
  # Jordan trend line
  geom_smooth(
    data = jordan_df,
    aes(x = education_spending, y = gdp_growth),
    method = "lm",
    se = FALSE,
    color = "red"
  ) +
  
  labs(
    title = "Education Spending vs GDP Growth: Jordan vs Global",
    x = "Education Spending (% of GDP)",
    y = "GDP Growth (%)",
    caption = "Grey points represent global observations; red points represent Jordan"
  ) +
  theme_minimal()

# Display the plot
p_jordan

ggsave(
  "outputs/eda_figures/jordan_vs_global_scatter.png",
  p_jordan,
  width = 8,
  height = 6
)

# --------------------------------
# Global average education spending over time
# --------------------------------
# We compute the global mean education spending per year
# to compare long-term trends with Jordan.
# --------------------------------

global_trend <- df_trimmed %>%
  group_by(year) %>%
  summarise(
    avg_education_spending = mean(education_spending, na.rm = TRUE)
  )

head(global_trend)
tail(global_trend)


# --------------------------------
# Education spending over time: Jordan vs Global
# --------------------------------
# This plot compares the evolution of education spending
# in Jordan with the global average over time.
# --------------------------------

p_time <- ggplot() +
  # Global average trend
  geom_line(
    data = global_trend,
    aes(x = year, y = avg_education_spending),
    color = "blue",
    linewidth = 1
  ) +
  
  # Jordan trend
  geom_line(
    data = jordan_df,
    aes(x = year, y = education_spending),
    color = "red",
    linewidth = 1
  ) +
  
  labs(
    title = "Education Spending Over Time: Jordan vs Global Average",
    x = "Year",
    y = "Education Spending (% of GDP)",
    caption = "Blue line: Global average | Red line: Jordan"
  ) +
  theme_minimal()

# Display plot
p_time

ggsave(
  "outputs/eda_figures/education_spending_trends.png",
  p_time,
  width = 9,
  height = 6
)

# --------------------------------
# 5. Histograms for all numeric variables
# --------------------------------
hist_df <- df %>%
  select(
    education_spending,
    gdp_growth,
    unemployment,
    inflation,
    population_growth
  ) %>%
  pivot_longer(
    cols = everything(),
    names_to = "variable",
    values_to = "value"
  )

p_hist <- ggplot(hist_df, aes(x = value)) +
  geom_histogram(
    bins = 30,
    fill = "steelblue",
    color = "white",
    alpha = 0.8
  ) +
  facet_wrap(~ variable, scales = "free") +
  labs(
    title = "Distributions of Key Economic Variables",
    x = "Value",
    y = "Frequency"
  ) +
  theme_minimal()

ggsave(
  "outputs/eda_figures/histograms_all_variables.png",
  p_hist,
  width = 10,
  height = 8
)
