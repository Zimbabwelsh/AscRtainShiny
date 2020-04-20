library(shinydashboard)
library(shiny)

#remotes::install_github("explodecomputer/AscRtain")
#remotes::install_github("explodecomputer/AscRtain")
library(AscRtain)


ui <- dashboardPage(
  dashboardHeader(title="Using AscRtain"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Theory", tabName="first", icon = icon("book-reader")),
      menuItem("Estimation", tabName="second", icon=icon("calculator")),
      menuItem("Documentation", tabName="third", icon=icon("book")),
      menuItem("Shiny Source Code", tabName="fourth", icon=icon("file-code"))
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName="first", 
              h2("Underpinning Theory"),
              box("Example text - populate from draft Hemani et al. group analysis
                  & discussion"),
              box("Diagram"),
              box(h4("References"),
                  p("Groenwold et al. 2020, 'Conditioning on a mediator to adjust for unmeasured confounding',  OSF Preprint"),
                  a(href="https://osf.io/vrcuf", "https://osf.io/vrcuf"),
                  br(), br(),
                  p("AscRtain documentation on Github"),
                  a(href="github.com/explodecomputer/AscRtain", "github.com/explodecomputer/AscRtain"))),
      tabItem(tabName="second",
              fluidRow(
                column(2, p("This shiny app demonstrates some of the functional",
                                 "utility of the", strong("AscRtain"), " R Package. The function",
                                 "here explores the possible parameter space which",
                                 "could give rise to an observed OR between exposure",
                                 "and outcome. This plots the possible selection effects",
                                 "(entered as BA and BY) which could give rise to an",
                                 "observed OR under a true known OR of 1.")),
                column(3, h5("Observed Relationship"),
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
                                   value = 0.1, min= 0.0001, max=1),
                       sliderInput(inputId = "num5", label = "P(A=1 & Y=1)",
                                   value = 0, min = 0, max=1)
                       ),
                column(3, h5("Selection Effects"),
                       sliderInput(inputId = "num6", label = "b0_range",
                                   value=c(0,0.1), min=0, max=1),
                       sliderInput(inputId = "num7", label = "ba_range",
                                   value=c(-0.2,0.2), min=-0.5, max=0.5),
                       sliderInput(inputId = "num8", label = "by_range", 
                                   value=c(-0.2,0.2), min=-0.5, max=0.5),
                       sliderInput(inputId = "num9", label = "bay_range",
                                   value=c(0,0.1), min=0, max=1)
                       ),
              mainPanel(
                fluidRow(column(6, plotOutput("scatter", width="750px", height="600px"))),
              ))),
      tabItem(tabName="third",
              h2("Documentation")),
      tabItem(tabName="fourth",
              h2("Shiny Source Code"))
      )
  
  
  ))


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

shinyApp(ui = ui, server = server)
