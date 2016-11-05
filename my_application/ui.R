#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(gridExtra)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
  # Application title
  titlePanel("Distribution and Means"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
        p("first choose a number of points"),
        sliderInput("bins","Number of bins:",min = 100,max = 5000,value = 500,step=100)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
        h4("Graphical representation of the random X and Y"),
        plotOutput("plot1", brush = "plot_brush"),
        p("the red line represent the linear regression between X and Y"),
        h3("Select a sub set of points to plot it and compare the distribution and means"),
        plotOutput("plot2"),
        p("the red line and distributions corresponds to all the data points"),
        p("the blue line and distribution corresponds to the subset of data points"),
        p("the vertical lines in the distribution are the means")
    )
  )
))
