# library('shiny')

####
## Load data and other info.
####

# Load necessary packages
library(beeswarm)
library(lava)
# Load data
data(serotonin, package = 'lava')

# Mean-center continuous variables.
serotonin$age.orig <- serotonin$age
serotonin$mem.orig <- serotonin$mem
serotonin$age <- mean(serotonin$age.orig) - serotonin$age.orig
serotonin$mem <- mean(serotonin$mem.orig) - serotonin$mem.orig

# Region and predictors name lists.
region <- c('cau', 'th', 'put', 'mid')
region.name <- c('Caduate', 'Thalamus', 'Putamen', 'Midbrain')
pred <- c('age', 'mem', 'gene1', 'gene2')
pred.name <- c('Age', 'Memory Performance', 'Gene Variant 1', 'Gene Variant 2')

####
## shinyServer
####

shinyServer(
  function(input,output){
    # Reactively update region selected and corresponding name.
    reg_plot <- reactive({region[as.numeric(input$region)]})
    reg_plot.name <- reactive({region.name[as.numeric(input$region)]})
    
    # Reactively update predictors selected.
    pred_set <- reactive({pred[as.numeric(input$pred)]})
    
    # Reactively update x-axis selected and corresponding name.
    x_axis_sel <- reactive({pred[as.numeric(input$x_axis)]})
    x_axis_sel.name <- reactive({pred.name[as.numeric(input$x_axis)]})
    
    # Plot to be shown.
    output$newPlot <- renderPlot({
      
      # Nothing to plot if "Go button!" has not been pressed.
      if (input$fit == 0) {}
      else {
        
        # Each time the "Go button!" is pressed...
        isolate({
          
          # Update equation, linear model and residual (to plot)
          f <- paste(reg_plot(), '~', paste(pred_set(), collapse = '+'))
          l <- lm(f, data = serotonin)
          adj <- l$residuals + l$coefficients[1] + l$coefficients[x_axis_sel()]*l$model[,x_axis_sel()]
          
          # If x-axis = 1 or 2 then a scatterplot is produced. If x-axis = 3 or 4 then a beeswarm plot is produced.
          if (as.numeric(input$x_axis) < 3){
            
            # Scatterplot
            plot(adj ~ serotonin[,x_axis_sel()], pch = 19, cex = 1.2, col = 'darkblue', bty = 'l', las = 1, xlab = x_axis_sel.name(), ylab = reg_plot.name())
            # Fit line
            abline(a = l$coefficients[1], b = l$coefficients[x_axis_sel()], col = 'darkblue', lwd = 3)
            
            # Title
            title(main = paste('Predicting ', reg_plot.name(), ' with ', x_axis_sel.name(), sep = ''), sub = paste('Covariates: ', paste(names(l$model)[-c(1, which(names(l$model) == x_axis_sel()))], collapse = ', '), sep = ''))
            
            # Margin text describing plotted association (estimate, 95%CI and p-value)
            mtext(paste(x_axis_sel.name(), ' estimate: ', signif(l$coefficients[x_axis_sel()],3), ', 95% CI: ', signif(confint(l)[x_axis_sel(),1],3), '; ', signif(confint(l)[x_axis_sel(),2],3), ', p = ', signif(summary(l)$coefficients[x_axis_sel(),4],3), sep = ''))
            
          } else if (as.numeric(input$x_axis) <= 5) {
            
            # Beeswarm plot
            beeswarm(adj ~ serotonin[,x_axis_sel()], pch = 19, cex = 1.2, col = 'darkblue', bty = 'l', las = 1, xlab = paste(x_axis_sel.name()), ylab = reg_plot.name())
            
            # Show population means
            points(c(1,2), c(l$coefficients[1], l$coefficients[1]+l$coefficients[x_axis_sel()]), cex = 2, col = 'darkorange', pch = 19)
            
            # Title
            title(main = paste('Predicting ', reg_plot.name(), ' with ', x_axis_sel.name(), sep = ''), sub = paste('Covariates: ', paste(names(l$model)[-c(1, which(names(l$model) == x_axis_sel()))], collapse = ', '), sep = ''))
            
            # Margin text describing plotted association (estimate, 95%CI and p-value) 
            mtext(paste(x_axis_sel.name(), ' estimate: ', signif(l$coefficients[x_axis_sel()],3), ', 95% CI: ', signif(confint(l)[x_axis_sel(),1],3), '; ', signif(confint(l)[x_axis_sel(),2],3), ', p = ', signif(summary(l)$coefficients[x_axis_sel(),4],3), sep = ''))
          }
        })
      }
    })
  }
)