library(shinydashboard)
library(shiny)

#remotes::install_github("explodecomputer/AscRtain")
#remotes::install_github("explodecomputer/AscRtain")
library(AscRtain)


ui <- fluidPage( 
  
  titlePanel("AscRtain Functionality"),
  
  fluidRow(
    column(3, p("This shiny app demonstrates some of the functional",
                       "utility of the", strong("AscRtain"), " R Package. The function",
                       "here explores the possible parameter space which",
                       "could give rise to an observed OR between exposure",
                       "and outcome. This plots the possible selection effects",
                       "(entered as BA and BY) which could give rise to an",
                       "observed OR under a true known OR of 1.")),
    column(3, h4("Observed Relationship"),
           sliderInput(inputId="num1", label = "Observed OR",
                       value=2, min=0, max=10, step=0.01),
           br(),
           sliderInput(inputId="num10", label = "Granularity", 
                       value=100, min=10, max=200)
    ),
    column(3, h5("Population Parameters"),
           sliderInput(inputId="num2", label = "P(S=1)",
                          value = 0.0275, min=0.0001, max=1),
           sliderInput(inputId="num3", label = "P(A=1)",
                       value = 0.15, min= 0.0001, max=1),
           sliderInput(inputId = "num4",label = "P(Y=1)",
                       value = 0.1, min= 0.0001, max=1)
    ),
    column(3, h5("Selection Effects"),
           sliderInput(inputId = "num6", label = "b0_range",
                          value=c(0,0.1), min=0, max=1),
           sliderInput(inputId = "num7", label = "ba_range",
                       value=c(-0.2,0.2), min=-0.5, max=0.5),
           sliderInput(inputId = "num8", label = "by_range", 
                       value=c(-0.2,0.2), min=-0.5, max=0.5)
    )
                 
  ),
  
  mainPanel(
                 
                 plotOutput("scatter")
                 )
  )


server <- function(input, output) {
  
  output$scatter <- renderPlot({
    
    x <- VBB$new()
    x$parameter_space(
           target_or=input$num1, 
           pS=input$num2, 
           pA=input$num3,
           pY=input$num4,
           pAY=0,
           b0_range=input$num6, 
           ba_range=input$num7, 
           by_range=input$num8, 
           bay_range=c(0,0), 
           granularity=input$num10
      )
    x$scatter()
    })

}

shinyApp(ui = ui, server= server)