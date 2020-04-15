library(shinydashboard)
library(shiny)

#remotes::install_github("explodecomputer/AscRtain")
#remotes::install_github("explodecomputer/AscRtain")
library(AscRtain)


ui <- fluidPage( "AscRtain Functionality",
                 sliderInput(inputId="num1", label = "Observed OR",
                             value=2, min=0, max=10),
                 sliderInput(inputId="num2", label = "P(S=1)", 
                             value = 0.0275, min=0.0001, max=1),
                 sliderInput(inputId="num3", label = "P(A=1)",
                             value = 0.15, min= 0.0001, max=1),
                 sliderInput(inputId = "num4",label = "P(Y=1)",
                             value = 0.1, min= 0.0001, max=1),
                 sliderInput(inputId = "num5", label = "P(A=1 & Y=1)",
                             value = 0, min=0, max=0),
                 sliderInput(inputId = "num6", label = "b0_range",
                             value=c(0,1), min=0, max=1),
                 sliderInput(inputId = "num7", label = "ba_range",
                             value=c(-0.2,0.2), min=-0.5, max=0.5),
                 sliderInput(inputId = "num8", label = "by_range", 
                             value=c(-0.2,0.2), min=-0.5, max=0.5),
                 sliderInput(inputId = "num9", label = "bay_range",
                             value= c(0,0), min=0, max=0),
                 sliderInput(inputId="num10", label = "Granularity", 
                             value=100, min=10, max=200),
                 
                 
                 
                 plotOutput("scatter")
                 )

server <- function(input, output) {
  
  output$scatter <- renderPlot({
    
    x <- VBB$new()
    x$parameter_space(
           target_or=input$num1, 
           pS=input$num2, 
           pA=input$num3,
           pY=input$num4,
           pAY=input$num5,
           b0_range=input$num6, 
           ba_range=input$num7, 
           by_range=input$num8, 
           bay_range=input$num9, 
           granularity=input$num10
      )
    x$scatter()
    })

}

shinyApp(ui = ui, server= server)
