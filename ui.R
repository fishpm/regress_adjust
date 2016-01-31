# runApp('~/Desktop/coursera/developing_data_products/project/', display.mode = 'showcase')

####
## shinyUI
####

# Type of page.
shinyUI(pageWithSidebar(
  # Header
  headerPanel('Visualizing adjusted linear regression'),
  # Contents of sidebar
  sidebarPanel(
    # Select region to plot
    selectInput("region", label = h3("Brain region"), choices = list("Caudate" = 1, "Thalamus" = 2, "Putamen" = 3, "Midbrain" = 4)),
    # Select covariates
    checkboxGroupInput('pred', label = h3('Predictors'), choices = list('Age' = 1, 'Memory Performance' = 2, 'Gene Variant 1' = 3, 'Gene Variant 2' = 4), selected = 0),
    # Select x-axis variable.
    selectInput('x_axis', label = h3('Predictor to plot'), choices = list('Age' = 1, 'Memory Performance' = 2, 'Gene Variant 1' = 3, 'Gene Variant 2' = 4)),
    # Go button!
    actionButton('fit', 'Fit model!')
  ),
  mainPanel(
    plotOutput('newPlot')
  )
))