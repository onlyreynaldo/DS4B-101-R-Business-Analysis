# TIDY DATA EXAMPLE ----

library(tidyverse)
library(readxl)


bikeshop_revenue_wide_tbl <- read_excel("02_data_wrangling/bikeshop_revenue_formatted_wide.xlsx")

# Wide Format ----

bikeshop_revenue_wide_tbl


# Long Format ----

bikeshop_revenue_long_tbl <- bikeshop_revenue_wide_tbl %>% 
    select(-Total) %>% 
    pivot_longer(cols = c("Mountain", "Road"), 
                 names_to = "category", 
                 values_to = "sales")

bikeshop_revenue_long_tbl


# Analyze

model <- lm(sales ~ ., data = bikeshop_revenue_long_tbl)

model
