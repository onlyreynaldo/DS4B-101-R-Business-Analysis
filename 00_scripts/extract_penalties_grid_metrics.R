# FUNCTION MOTIVATION
# ===================
# As discussed here https://github.com/tidymodels/parsnip/issues/195
# and here https://github.com/tidymodels/parsnip/issues/215, 
# by fitting a glmnet model, it also performs a fit method for each one of
# the lambda's, a.k.a penalty. 
# The function below allow us to access the performance metrics of these
# others parameters automatically created by the glmnet call.


#' Title 
#' Function to access the performance metrics of internals generated lambda/penalty values
#' of a glmnet fitted object
#'
#' @param glmnet_model a fitted glmnet model
#' @param new_data data to calculate the predictions
#' @param truth_col column that holds the true values that are being predicted
#'
#' @return a tibble with 3 columns: penalties, mae, rmse
#' @export
#'
#' @examples
#' extract_penalties_grid_metrics(glmnet_model = model_03_linear_glmnet,
#'                                new_data = test_tbl, 
#'                                truth_col = price)
#'                                
extract_penalties_grid_metrics <- function(glmnet_model, new_data, truth_col) {
    
    tibble(penalties = glmnet_model$fit$lambda) %>% 
        
        # Add the predictions for each lambda/penalty value
        mutate(preds_tbl = penalties %>% map(~ glmnet_model %>% predict(new_data, penalty = .x))) %>% 
        unnest(preds_tbl) %>% 
        
        # Add the price/truth value for the predictions
        mutate({{truth_col}} := new_data %>% pull({{truth_col}}) %>% rep(glmnet_model$fit$lambda %>% length())) %>% 
        
        # Calc metrics per penalty value
        group_by(penalties) %>%
        summarise(
            mae  = ({{truth_col}} - .pred) %>% abs() %>% mean(),
            rmse = ({{truth_col}} - .pred)^2 %>% mean() %>% sqrt()
        ) %>%
        ungroup()
    
}
