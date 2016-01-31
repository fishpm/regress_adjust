# regress_adjust
A simple shinyApp for visualizing the association between two variables (Y, X1) using ordinary least-squares (OLS) and visualizing how that association changes following the inclusion and exclusion of additional predictors.

## Usage
An example dataset is loaded ('serotonin' datset from the 'lava' package in R).  The user makes three selections
  1. User selects among four brain regions (caudate, thalamus, putamen, midbrain) where serotonin levels have been quanitifed using a brain imaging scan.
  2. User selects which among four variables to include as predictors in the linear regression models (age, memory performance, gene variant 1 allele groups, gene variant 2 allele groups).
  3. User selects which variable to plot against the brain region selected in 1.

The app plots the association between predictor selected in 3. against the brain region selected in 1., adjusting for other variables in the model. The plot includes information about the association between these two variables (parameter estimate, 95% confidence interval and p-value).


