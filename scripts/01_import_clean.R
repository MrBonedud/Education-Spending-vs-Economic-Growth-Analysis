# ================================
# 01_import_clean.R
# Reshape & Clean WDI Data
# ================================

library(tidyverse)
library(janitor)

# 1. Load raw data
raw_data <- read_csv(
  "data/raw/wdi_education_growth_2000_2024.csv",
  show_col_types = FALSE
)

# 2. Clean column names
raw_data <- raw_data %>%
  clean_names()

# 3. Keep only selected indicators (NSE-safe)
indicators <- c(
  "SE.XPD.TOTL.GD.ZS",
  "NY.GDP.MKTP.KD.ZG",
  "SL.UEM.TOTL.ZS",
  "FP.CPI.TOTL.ZG",
  "SP.POP.GROW"
)

raw_data <- raw_data %>%
  dplyr::filter(.data$series_code %in% indicators)

# 4. Wide → long (years)
data_long <- raw_data %>%
  pivot_longer(
    cols = matches("^x\\d{4}_yr\\d{4}$"),
    names_to = "year",
    values_to = "value"
  )

# 5. Extract numeric year
data_long <- data_long %>%
  mutate(year = as.integer(stringr::str_extract(year, "\\d{4}")))

# 6. Long → wide (indicators)
data_wide <- data_long %>%
  select(country_name, country_code, year, series_code, value) %>%
  pivot_wider(
    names_from = series_code,
    values_from = value
  )

# 7. Rename indicators (dot-safe)
data_clean <- data_wide %>%
  rename(
    education_spending = `SE.XPD.TOTL.GD.ZS`,
    gdp_growth         = `NY.GDP.MKTP.KD.ZG`,
    unemployment       = `SL.UEM.TOTL.ZS`,
    inflation          = `FP.CPI.TOTL.ZG`,
    population_growth  = `SP.POP.GROW`
  )

# 8. Convert indicators to numeric
data_clean <- data_clean %>%
  mutate(
    across(
      c(
        education_spending,
        gdp_growth,
        unemployment,
        inflation,
        population_growth
      ),
      as.numeric
    )
  )

# 9. Remove rows missing core variables (NSE-safe)
data_clean <- data_clean %>%
  dplyr::filter(
    !is.na(.data$education_spending),
    !is.na(.data$gdp_growth)
  )

# 10. Save cleaned data
write_csv(
  data_clean,
  "data/cleaned/wdi_cleaned.csv"
)

