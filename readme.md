# Education Spending vs Economic Growth Analysis

## Project Overview

This project analyzes the relationship between public education spending (as a percentage of GDP) and economic growth across countries from 2000-2024. Using data from the World Bank's World Development Indicators (WDI), we explore whether increased investment in education correlates with improved GDP growth and identify the key economic factors that influence this relationship.

Education expenditure is examined in relation to annual GDP growth rates, alongside additional macroeconomic variables including unemployment, inflation, and population growth. The study follows a structured data science workflow encompassing data import, cleaning, exploratory data analysis (EDA), modeling, and evaluation using the R programming language.

### Research Question

**Does increased public spending on education lead to higher economic growth?**

## Data Source

- **World Development Indicators (WDI)** database
- **Time Period**: 2000-2024
- **Indicators Used**:
  - SE.XPD.TOTL.GD.ZS - Education spending (% of GDP)
  - NY.GDP.MKTP.KD.ZG - GDP growth (annual %)
  - SL.UEM.TOTL.ZS - Unemployment rate (% of labor force)
  - FP.CPI.TOTL.ZG - Inflation rate (annual %)
  - SP.POP.GROW - Population growth (annual %)

## Project Structure

```
📁 Education Spending vs Economic Growth Analysis/
├── 📄 readme.md                              # This file
├── 📄 Education Spending vs Economic Growth Analysis.Rproj  # R Project file
├── 📁 data/
│   ├── 📁 raw/                               # Original WDI data files
│   │   ├── wdi_education_growth_2000_2024.csv
│   │   └── c62da767-822d-4f3e-9a3d-74b268f9bb3c_Series - Metadata.csv
│   └── 📁 cleaned/                           # Processed data ready for analysis
│       └── wdi_cleaned.csv
├── 📁 scripts/                               # Analysis pipeline scripts
│   ├── 01_import_clean.R                     # Data import and cleaning
│   ├── 02_eda.R                              # Exploratory data analysis
│   ├── 03_model.R                            # Model development
│   └── 04_evaluate.R                         # Model evaluation and metrics
├── 📁 outputs/                               # Generated outputs
│   ├── 📁 eda_figures/                       # Exploratory plots
│   ├── 📁 plots/                             # Final visualization plots
│   └── 📁 models/                            # Model files and results
│       ├── random_forest_model.rds           # Trained random forest model
│       ├── table_3_regression_results.csv    # Regression model summaries
│       └── ml_evaluation_metrics.csv         # Model performance metrics
└── 📁 reports/                               # Final reports and documentation
```

## How to Run the Analysis

### Prerequisites

Ensure you have R (version 4.0+) installed. The following packages are required:

- `tidyverse` - Data manipulation and visualization
- `janitor` - Data cleaning utilities
- `broom` - Model results tidying
- `caret` - Machine learning framework

Install missing packages with:

```r
install.packages(c("tidyverse", "janitor", "broom", "caret"))
```

### Running the Pipeline

Execute the analysis scripts in order:

1. **Data Import & Cleaning** (required first)

   ```r
   source("scripts/01_import_clean.R")
   ```

   - Imports raw WDI data
   - Cleans column names and data structure
   - Filters for selected economic indicators
   - Outputs: `data/cleaned/wdi_cleaned.csv`

2. **Exploratory Data Analysis**

   ```r
   source("scripts/02_eda.R")
   ```

   - Generates scatter plots of education spending vs GDP growth
   - Produces visualizations by country development status
   - Creates time series analysis plots
   - Outputs: Multiple PNG figures in `outputs/eda_figures/` and `outputs/plots/`

3. **Model Development**

   ```r
   source("scripts/03_model.R")
   ```

   - Builds baseline linear regression model
   - Develops multiple regression models with additional predictors
   - Trains random forest machine learning model
   - Performs cross-validation
   - Outputs: `outputs/models/random_forest_model.rds`, `outputs/models/table_3_regression_results.csv`

4. **Model Evaluation**
   ```r
   source("scripts/04_evaluate.R")
   ```
   - Evaluates model performance metrics
   - Calculates predictions on test data
   - Compares model accuracy and efficiency
   - Outputs: `outputs/models/ml_evaluation_metrics.csv`, `outputs/models/ml_predictions.csv`

### Quick Start (Run All Scripts)

To run the complete analysis pipeline at once:

```r
# Open the .Rproj file in RStudio, then run:
source("scripts/01_import_clean.R")
source("scripts/02_eda.R")
source("scripts/03_model.R")
source("scripts/04_evaluate.R")
```

## Analysis Pipeline Summary

### Script 1: Data Import & Cleaning (`01_import_clean.R`)

- Loads raw WDI data from CSV files
- Standardizes column names using `janitor::clean_names()`
- Filters to include only the 5 key economic indicators
- Handles missing values and data validation
- Outputs cleaned dataset for downstream analysis

### Script 2: Exploratory Data Analysis (`02_eda.R`)

- **Global Analysis**: Explores overall relationship between education spending and GDP growth
- **Country-Level Analysis**: Analyzes patterns by country
- **Development Status**: Compares high-income vs developing countries
- **Temporal Analysis**: Examines trends over time
- Produces publication-quality visualizations with trend lines and confidence intervals

### Script 3: Model Development (`03_model.R`)

- **Model 1 (Baseline)**: Simple linear regression with only education spending
- **Model 2-3 (Extended)**: Adds unemployment, inflation, and population growth as predictors
- **Random Forest**: Non-parametric machine learning approach for prediction
- Uses cross-validation to prevent overfitting
- Selects best performing model based on evaluation metrics

### Script 4: Model Evaluation (`04_evaluate.R`)

- Calculates key performance metrics (R², RMSE, MAE)
- Compares regression models and machine learning approach
- Generates predictions on held-out test data
- Produces evaluation summary tables

## Key Outputs

| File                             | Description                                               |
| -------------------------------- | --------------------------------------------------------- |
| `wdi_cleaned.csv`                | Cleaned dataset ready for analysis                        |
| `random_forest_model.rds`        | Trained predictive model (can be loaded with `readRDS()`) |
| `table_3_regression_results.csv` | Regression model coefficients and statistics              |
| `ml_evaluation_metrics.csv`      | Model performance comparison (R², RMSE, MAE)              |
| `ml_predictions.csv`             | Model predictions vs actual values                        |
| `eda_figures/`                   | Exploratory data analysis visualizations                  |
| `plots/`                         | Final publication-quality figures                         |

## Key Findings

The analysis reveals:

- **Weak Global Correlation**: Education spending shows a weak and noisy relationship with GDP growth at the global level, with substantial dispersion indicating considerable heterogeneity across countries and time periods
- **Complex Relationships**: The relationship between education spending and economic growth is complex and indirect, influenced by multiple macroeconomic factors
- **Model Performance**: The Random Forest model achieved **RMSE: 3.54** and **R² = 0.171** on the test set, capturing general trends while leaving significant variation unexplained
- **Contextual Factors**: Unemployment, inflation, and population growth significantly influence economic outcomes beyond education spending alone
- **Structural Importance**: While education spending is structurally important for long-term development, it is insufficient on its own to explain short-term GDP growth fluctuations

## Dependencies

All analysis scripts use the following R packages:

- **Data processing**: `tidyverse`, `janitor`
- **Modeling**: `caret`, `broom`
- **Visualization**: `ggplot2` (included in tidyverse)

## Limitations

- The study relies on aggregate country-level indicators, which may mask important within-country dynamics and institutional factors
- The set of explanatory variables is limited and does not capture political, technological, or external economic shocks that strongly influence growth outcomes
- The analysis is observational in nature and does not establish causal relationships
- Results should be interpreted as descriptive and predictive rather than causal inferences

## Notes

- GDP growth values are trimmed to ±20% to remove extreme outliers during analysis
- All monetary values are in constant 2015 USD
- Missing data was handled by removing observations lacking education spending or GDP growth values
- No imputation methods were applied to maintain transparency
- Random seeds were fixed to ensure reproducible results across runs
- The unit of analysis is country-year, capturing both cross-country variation and temporal changes

## Future Work

Potential extensions to this analysis include:

- Incorporating a broader range of variables (institutional, political, technological factors)
- Analyzing longer time horizons and country-specific patterns
- Exploring within-country dynamics and subnational variation
- Incorporating external economic shocks and policy changes
- Applying alternative modeling approaches to capture additional complexity

## Future Work

Potential extensions to this analysis include:

- Incorporating a broader range of variables (institutional, political, technological factors)
- Analyzing longer time horizons and country-specific patterns
- Exploring within-country dynamics and subnational variation
- Incorporating external economic shocks and policy changes
- Applying alternative modeling approaches to capture additional complexity

## References

World Bank. (n.d.). _World Development Indicators_. Retrieved from https://databank.worldbank.org/source/world-development-indicators

R Core Team. (2023). _R: A Language and Environment for Statistical Computing_. R Foundation for Statistical Computing, Vienna, Austria.

Wickham, H., et al. (2019). Welcome to the tidyverse. _Journal of Open Source Software_, 4(43), 1686.

Wickham, H. (2016). _ggplot2: Elegant Graphics for Data Analysis_ (2nd ed.). Springer-Verlag.

Kuhn, M. (2023). _caret: Classification and Regression Training_. R package documentation.

---

**Last Updated**: December 2025
