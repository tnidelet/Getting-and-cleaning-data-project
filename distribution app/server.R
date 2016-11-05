#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
    table <- reactive({
        X <- rnorm(input$bins,mean=25)
        Y <- X*0.9 + rnorm(input$bins)
        data.frame(X,Y)
    })
    
    reg.1 <- reactive({
        lm(Y~X,data=table())
    })
    
    output$plot1 <- renderPlot({
        pMain <- ggplot(table(),aes(X,Y))+
            geom_point(color=rgb(1,0,0,0.5))+
            geom_abline(intercept = reg.1()$coefficients[1],slope = reg.1()$coefficients[2],col=2)+
            theme(panel.background = element_blank())
        
        pMain
    })
    
    output$plot2 <- renderPlot({
        if(is.null(input$plot_brush)) return(NULL)
        sub_data <- brushedPoints(table(), input$plot_brush, xvar = "X", yvar = "Y")
        reg.2 <- lm(Y~X,data=sub_data)
        
        pMain <- ggplot(table(),aes(X,Y))+
            geom_point(color=rgb(1,0,0,0.5))+
            annotate("point",x=sub_data$X,y=sub_data$Y,color=rgb(0,0,1,0.5))+
            geom_abline(intercept = reg.1()$coefficients[1],slope = reg.1()$coefficients[2],col=2)+
            geom_abline(intercept = reg.2$coefficients[1],slope = reg.2$coefficients[2],col=4)+
            theme(panel.background = element_blank())
        
        pTop <- ggplot(table(),aes(X))+
            geom_histogram(bins = 30,fill="red",alpha=0.8)+
            geom_histogram(data = sub_data, fill = "blue", alpha = 0.8,bins = 30) +
            geom_vline(xintercept = mean(table()$X),col=2)+
            geom_vline(xintercept = mean(sub_data$X),col=4)+
            theme(panel.background = element_blank())
        
        pRight <- ggplot(table(),aes(Y))+
            geom_histogram(bins = 30,fill="red",alpha=0.8)+
            geom_histogram(data = sub_data, fill = "blue", alpha = 0.8,bins = 30) +
            geom_vline(xintercept = mean(table()$Y),col=2)+
            geom_vline(xintercept = mean(sub_data$Y),col=4)+
            coord_flip()+
            theme(panel.background = element_blank())
        
        pEmpty <- ggplot(table(), aes(x = X, y = Y)) +
            geom_blank() +
            theme(axis.text = element_blank(),
                  axis.title = element_blank(),
                  line = element_blank(),
                  panel.background = element_blank())
        
        
        grid.arrange(pTop, pEmpty, pMain, pRight,ncol = 2, nrow = 2, widths = c(3, 1), heights = c(1, 3))
    })
  
})
